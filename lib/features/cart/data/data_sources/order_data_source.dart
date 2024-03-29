import 'dart:convert';

import 'package:flutter_vtv/features/cart/domain/dto/place_order_param.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/order_resp.dart';

abstract class OrderDataSource {
  Future<DataResponse<OrderResp>> createByCartIds(List<String> cartIds);
  Future<DataResponse<OrderResp>> createUpdateWithCart(PlaceOrderParam param);

  Future<DataResponse<OrderResp>> placeOrder(PlaceOrderParam params);
}

class OrderDataSourceImpl extends OrderDataSource {
  OrderDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<OrderResp>> createByCartIds(List<String> cartIds) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateByCartIdsURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(cartIds),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderCreateByCartIdsURL,
      (data) => OrderResp.fromMap(data),
    );
  }

  @override
  Future<DataResponse<OrderResp>> createUpdateWithCart(PlaceOrderParam param) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateUpdateWithCartURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: param.toJson(),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderCreateUpdateWithCartURL,
      (data) => OrderResp.fromMap(data),
    );
  }
  
  @override
  Future<DataResponse<OrderResp>> placeOrder(PlaceOrderParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderAddWithCartURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderAddWithCartURL,
      (data) => OrderResp.fromMap(data),
    );
  }
}
