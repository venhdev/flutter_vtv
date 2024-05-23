import 'dart:convert';

import 'package:http/http.dart' as http show Client;
import 'package:vtv_common/cart.dart';
import 'package:vtv_common/core.dart';

import '../../../../core/constants/customer_api.dart';

abstract class CartDataSource {
  Future<SuccessResponse<CartResp>> getCarts();
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
  Future<SuccessResponse<CartResp>> getCarts() async {
    final url = uriBuilder(path: kAPICartGetListURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<CartResp>(
      response,
      url,
      (data) => CartResp.fromMap(data),
    );
  }

  @override
  Future<SuccessResponse> addToCart(int productVariantId, int quantity) async {
    final body = {
      'productVariantId': productVariantId.toString(),
      'quantity': quantity.toString(),
    };

    final url = uriBuilder(path: kAPICartAddURL);

    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }

  @override
  Future<SuccessResponse> deleteToCart(String cartId) async {
    final url = uriBuilder(path: '$kAPICartDeleteURL/$cartId');
    final response = await _client.delete(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }

  @override
  Future<SuccessResponse> deleteToCartByShopId(String shopId) async {
    final url = uriBuilder(path: '$kAPICartDeleteByShopIdURL/$shopId');
    final response = await _client.delete(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }

  @override
  Future<SuccessResponse> updateCart(String cartId, int quantity) async {
    final url = uriBuilder(
      path: '$kAPICartUpdateURL/$cartId',
      queryParameters: {
        'quantity': quantity.toString(),
      },
    );
    final response = await _client.put(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      // body: jsonEncode({
      //   'quantity': quantity,
      // }),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }
}
