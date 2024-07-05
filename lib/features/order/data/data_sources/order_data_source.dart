import 'dart:convert';

import 'package:flutter_vtv/features/order/domain/dto/multiple_order_request_param.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/constants/customer_api.dart';

abstract class OrderDataSource {
  //# Create Temp Order
  // * With Cart
  Future<SuccessResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds);
  Future<SuccessResponse<OrderDetailEntity>> createUpdateWithCart(OrderRequestWithCartParam params);
  // * With Product Variant
  Future<SuccessResponse<OrderDetailEntity>> createByProductVariant(
      Map<int, int> mapParam); //int productVariantId, int quantity
  Future<SuccessResponse<OrderDetailEntity>> createUpdateWithVariant(OrderRequestWithVariantParam params);

  //# Place order
  Future<SuccessResponse<OrderDetailEntity>> placeOrderWithCart(OrderRequestWithCartParam params);
  Future<SuccessResponse<OrderDetailEntity>> placeOrderWithVariant(OrderRequestWithVariantParam params);

  //# Multi Order
  Future<SuccessResponse<MultipleOrderResp>> createMultiOrderByCartIds(List<String> cartIds);
  Future<SuccessResponse<MultipleOrderResp>> createMultiOrderByRequest(MultipleOrderRequestParam params);
  Future<SuccessResponse<MultipleOrderResp>> placeMultiOrderByRequest(MultipleOrderRequestParam params);

  //# Manage orders
  Future<SuccessResponse<MultiOrderEntity>> getListOrders();
  Future<SuccessResponse<MultiOrderEntity>> getListOrdersByStatus(String status);
  Future<SuccessResponse<OrderDetailEntity>> getOrderDetail(String orderId);
  Future<SuccessResponse<OrderDetailEntity>> cancelOrder(String orderId);
  Future<SuccessResponse<OrderDetailEntity>> returnOrder(String orderId);
  Future<SuccessResponse<OrderDetailEntity>> completeOrder(String orderId);
}

class OrderDataSourceImpl extends OrderDataSource {
  OrderDataSourceImpl(
    this._dio,
    this._client,
    this._secureStorageHelper,
  );

  final http.Client _client;
  final dio.Dio _dio;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<SuccessResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds) async {
    final url = uriBuilder(path: kAPIOrderCreateByCartIdsURL);
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
  Future<SuccessResponse<OrderDetailEntity>> createUpdateWithCart(OrderRequestWithCartParam params) async {
    final url = uriBuilder(path: kAPIOrderCreateUpdateWithCartURL);
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
  Future<SuccessResponse<OrderDetailEntity>> placeOrderWithCart(OrderRequestWithCartParam params) async {
    final url = uriBuilder(path: kAPIOrderAddWithCartURL);
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
  Future<SuccessResponse<MultiOrderEntity>> getListOrders() async {
    final url = uriBuilder(path: kAPIOrderListURL);
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
  Future<SuccessResponse<MultiOrderEntity>> getListOrdersByStatus(String status) async {
    final url = uriBuilder(path: '$kAPIOrderListByStatusURL/$status');
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
  Future<SuccessResponse<OrderDetailEntity>> createByProductVariant(Map<int, int> mapParam) async {
    final url = uriBuilder(path: kAPIOrderCreateByProductVariantURL);
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
  Future<SuccessResponse<OrderDetailEntity>> createUpdateWithVariant(OrderRequestWithVariantParam params) async {
    final url = uriBuilder(path: kAPIOrderCreateUpdateWithProductVariantURL);
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
  Future<SuccessResponse<OrderDetailEntity>> placeOrderWithVariant(OrderRequestWithVariantParam params) async {
    final url = uriBuilder(path: kAPIOrderAddWithProductVariantURL);
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
  Future<SuccessResponse<OrderDetailEntity>> getOrderDetail(String orderId) async {
    final url = uriBuilder(path: '$kAPIOrderDetailURL/$orderId');
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
  Future<SuccessResponse<OrderDetailEntity>> cancelOrder(String orderId) async {
    final url = uriBuilder(path: '$kAPIOrderCancelURL/$orderId');
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

  @override
  Future<SuccessResponse<OrderDetailEntity>> completeOrder(String orderId) async {
    final url = uriBuilder(path: '$kAPIOrderCompleteURL/$orderId');
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

  @override
  Future<SuccessResponse<MultipleOrderResp>> createMultiOrderByCartIds(List<String> cartIds) async {
    final url = uriBuilder(path: kAPIOrderCreateMultipleByCartIdsURL);
    final response = await _dio.postUri(
      url,
      data: cartIds,
    );

    return handleDioResponse<MultipleOrderResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => MultipleOrderResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<MultipleOrderResp>> createMultiOrderByRequest(MultipleOrderRequestParam params) async {
    final url = uriBuilder(path: kAPIOrderCreateMultipleByRequestURL);
    final response = await _dio.postUri(
      url,
      data: params.toMap(),
    );

    return handleDioResponse<MultipleOrderResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => MultipleOrderResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<MultipleOrderResp>> placeMultiOrderByRequest(MultipleOrderRequestParam params) async {
    final url = uriBuilder(path: kAPIOrderAddMultipleByRequestURL);
    final response = await _dio.postUri(
      url,
      data: params.toMap(),
    );

    return handleDioResponse<MultipleOrderResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => MultipleOrderResp.fromMap(dataMap),
    );
  }
  
  @override
  Future<SuccessResponse<OrderDetailEntity>> returnOrder(String orderId) async {
    final url = uriBuilder(path: '$kAPIOrderReturnURL/$orderId');
    final response = await _client.patch(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: orderId, //REVIEW: why the body is text?
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      url,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }
}
