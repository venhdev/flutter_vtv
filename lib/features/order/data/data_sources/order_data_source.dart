import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

abstract class OrderDataSource {
  //# Create Temp Order
  // * With Cart
  Future<DataResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds);
  Future<DataResponse<OrderDetailEntity>> createUpdateWithCart(PlaceOrderWithCartParam params);
  // * With Product Variant
  Future<DataResponse<OrderDetailEntity>> createByProductVariant(
      Map<int, int> mapParam); //int productVariantId, int quantity
  Future<DataResponse<OrderDetailEntity>> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  //# Place order
  Future<DataResponse<OrderDetailEntity>> placeOrderWithCart(PlaceOrderWithCartParam params);
  Future<DataResponse<OrderDetailEntity>> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  //# Manage orders
  Future<DataResponse<MultiOrderEntity>> getListOrders();
  Future<DataResponse<MultiOrderEntity>> getListOrdersByStatus(String status);
  Future<DataResponse<OrderDetailEntity>> getOrderDetail(String orderId);
  Future<DataResponse<OrderDetailEntity>> getOrderCancel(String orderId);
}

class OrderDataSourceImpl extends OrderDataSource {
  OrderDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds) async {
    final url = baseUri(path: kAPIOrderCreateByCartIdsURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(cartIds),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createUpdateWithCart(PlaceOrderWithCartParam params) async {
    final url = baseUri(path: kAPIOrderCreateUpdateWithCartURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> placeOrderWithCart(PlaceOrderWithCartParam params) async {
    final url = baseUri(path: kAPIOrderAddWithCartURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<MultiOrderEntity>> getListOrders() async {
    final url = baseUri(path: kAPIOrderListURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderEntity>(
      response,
      url,
      (dataMap) => MultiOrderEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<MultiOrderEntity>> getListOrdersByStatus(String status) async {
    final url = baseUri(path: '$kAPIOrderListByStatusURL/$status');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderEntity>(
      response,
      url,
      (dataMap) => MultiOrderEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createByProductVariant(Map<int, int> mapParam) async {
    final url = baseUri(path: kAPIOrderCreateByProductVariantURL);
    // final body = {
    //   productVariantId.toString(): quantity.toString(),
    // };
    final body = mapParam.map((key, value) => MapEntry(key.toString(), value.toString()));

    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createUpdateWithVariant(PlaceOrderWithVariantParam params) async {
    final url = baseUri(path: kAPIOrderCreateUpdateWithProductVariantURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> placeOrderWithVariant(PlaceOrderWithVariantParam params) async {
    final url = baseUri(path: kAPIOrderAddWithProductVariantURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> getOrderDetail(String orderId) async {
    final url = baseUri(path: '$kAPIOrderDetailURL/$orderId');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> getOrderCancel(String orderId) async {
    final url = baseUri(path: '$kAPIOrderCancelURL/$orderId');
    final response = await _client.patch(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }
}
