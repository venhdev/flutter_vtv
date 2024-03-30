import 'dart:convert';

import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../../cart/domain/dto/order_resp.dart';

abstract class OrderDataSource {
  // Create order
  Future<DataResponse<OrderResp>> createByCartIds(List<String> cartIds);
  Future<DataResponse<OrderResp>> createUpdateWithCart(PlaceOrderParam param);
  Future<DataResponse<OrderResp>> createByProductVariant(int productVariantId, int quantity);

  // Place order
  Future<DataResponse<OrderResp>> placeOrder(PlaceOrderParam params);

  // Manage orders
  Future<DataResponse<OrdersResp>> getListOrders();
  Future<DataResponse<OrdersResp>> getListOrdersByStatus(String status);
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

  @override
  Future<DataResponse<OrdersResp>> getListOrders() async {
    final response = await _client.get(
      baseUri(path: kAPIOrderListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<OrdersResp>(
      response,
      kAPIOrderListURL,
      (data) => OrdersResp.fromMap(data),
    );
  }

  @override
  Future<DataResponse<OrdersResp>> getListOrdersByStatus(String status) async {
    final response = await _client.get(
      baseUri(path: '$kAPIOrderListByStatusURL/$status'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<OrdersResp>(
      response,
      '$kAPIOrderListByStatusURL/$status',
      (data) => OrdersResp.fromMap(data),
    );
  }

  @override
  Future<DataResponse<OrderResp>> createByProductVariant(int productVariantId, int quantity) async {
    final body = {
      productVariantId.toString(): quantity.toString(),
    };

    final response = await _client.post(
      baseUri(path: kAPIOrderCreateByProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderCreateByProductVariantURL,
      (data) => OrderResp.fromMap(data),
    );
  }
}
