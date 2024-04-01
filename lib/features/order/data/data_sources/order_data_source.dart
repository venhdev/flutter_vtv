import 'dart:convert';

import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../../domain/dto/place_order_with_variant_param.dart';

abstract class OrderDataSource {
  // Create Temp Order
  // * With Cart
  Future<DataResponse<OrderResp>> createByCartIds(List<String> cartIds);
  Future<DataResponse<OrderResp>> createUpdateWithCart(PlaceOrderWithCartParam params);
  // * With Product Variant
  Future<DataResponse<OrderResp>> createByProductVariant(int productVariantId, int quantity);
  Future<DataResponse<OrderResp>> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  // Place order
  Future<DataResponse<OrderResp>> placeOrderWithCart(PlaceOrderWithCartParam params);
  Future<DataResponse<OrderResp>> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  // Manage orders
  Future<DataResponse<MultiOrderResp>> getListOrders();
  Future<DataResponse<MultiOrderResp>> getListOrdersByStatus(String status);
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
  Future<DataResponse<OrderResp>> createUpdateWithCart(PlaceOrderWithCartParam param) async {
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
  Future<DataResponse<OrderResp>> placeOrderWithCart(PlaceOrderWithCartParam params) async {
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
  Future<DataResponse<MultiOrderResp>> getListOrders() async {
    final response = await _client.get(
      baseUri(path: kAPIOrderListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderResp>(
      response,
      kAPIOrderListURL,
      (data) => MultiOrderResp.fromMap(data),
    );
  }

  @override
  Future<DataResponse<MultiOrderResp>> getListOrdersByStatus(String status) async {
    final response = await _client.get(
      baseUri(path: '$kAPIOrderListByStatusURL/$status'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderResp>(
      response,
      '$kAPIOrderListByStatusURL/$status',
      (data) => MultiOrderResp.fromMap(data),
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

  @override
  Future<DataResponse<OrderResp>> createUpdateWithVariant(PlaceOrderWithVariantParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateUpdateWithProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderCreateUpdateWithProductVariantURL,
      (data) => OrderResp.fromMap(data),
    );
  }

  @override
  Future<DataResponse<OrderResp>> placeOrderWithVariant(PlaceOrderWithVariantParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderAddWithProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderResp>(
      response,
      kAPIOrderAddWithProductVariantURL,
      (data) => OrderResp.fromMap(data),
    );
  }
}
