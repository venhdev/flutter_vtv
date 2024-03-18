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
  Future<SuccessResponse> updateCart(String cartId, int quantity);
  Future<SuccessResponse> deleteToCart(String cartId);
  Future<SuccessResponse> deleteToCartByShopId(String shopId);
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

  @override
  Future<SuccessResponse> deleteToCart(String cartId) async {
    final response = await _client.delete(
      baseUri(path: '$kAPICartDeleteURL/$cartId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      kAPICartDeleteURL,
    );
  }

  @override
  Future<SuccessResponse> deleteToCartByShopId(String shopId) async {
    final response = await _client.delete(
      baseUri(path: '$kAPICartDeleteByShopIdURL/$shopId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      kAPICartDeleteByShopIdURL,
    );
  }

  @override
  Future<SuccessResponse> updateCart(String cartId, int quantity) async {
    final response = await _client.put(
      baseUri(
        path: '$kAPICartUpdateURL/$cartId',
        queryParameters: {
          'quantity': quantity.toString(),
        },
      ),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      // body: jsonEncode({
      //   'quantity': quantity,
      // }),
    );

    return handleResponseNoData(
      response,
      kAPICartUpdateURL,
    );
  }
}
