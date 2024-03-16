import 'dart:convert';

import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/response/cart_resp.dart';

abstract class CartDataSource {
  Future<DataResponse<CartResp>> getCarts();
  Future<SuccessResponse> addToCart(int productVariantId, int quantity);
}

class CartDataSourceImpl extends CartDataSource {
  CartDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<CartResp>> getCarts() async {
    final response = await _client.get(
      baseUri(path: kAPICartGetListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<CartResp>(
      response,
      kAPICartGetListURL,
      (data) => CartResp.fromMap(data),
    );
  }

  @override
  Future<SuccessResponse> addToCart(int productVariantId, int quantity) async {
    final body = {
      'username': await _secureStorageHelper.username,
      'productVariantId': productVariantId.toString(),
      'quantity': quantity.toString(),
    };
    
    final response = await _client.post(
      baseUri(path: kAPICartAddURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(
      response,
      kAPICartGetListURL,
    );
  }
}
