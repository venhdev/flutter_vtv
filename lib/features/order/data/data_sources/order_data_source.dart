import 'dart:convert';

import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/order_detail_entity.dart';
import '../../domain/dto/place_order_with_variant_param.dart';
import '../../domain/entities/multi_order_entity.dart';

abstract class OrderDataSource {
  //# Create Temp Order
  // * With Cart
  Future<DataResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds);
  Future<DataResponse<OrderDetailEntity>> createUpdateWithCart(PlaceOrderWithCartParam params);
  // * With Product Variant
  Future<DataResponse<OrderDetailEntity>> createByProductVariant(int productVariantId, int quantity);
  Future<DataResponse<OrderDetailEntity>> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  //# Place order
  Future<DataResponse<OrderDetailEntity>> placeOrderWithCart(PlaceOrderWithCartParam params);
  Future<DataResponse<OrderDetailEntity>> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  //# Manage orders
  Future<DataResponse<MultiOrderEntity>> getListOrders();
  Future<DataResponse<MultiOrderEntity>> getListOrdersByStatus(String status);
  Future<DataResponse<OrderDetailEntity>> getOrderDetail(String orderId);
}

class OrderDataSourceImpl extends OrderDataSource {
  OrderDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<OrderDetailEntity>> createByCartIds(List<String> cartIds) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateByCartIdsURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(cartIds),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderCreateByCartIdsURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createUpdateWithCart(PlaceOrderWithCartParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateUpdateWithCartURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderCreateUpdateWithCartURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> placeOrderWithCart(PlaceOrderWithCartParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderAddWithCartURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderAddWithCartURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<MultiOrderEntity>> getListOrders() async {
    final response = await _client.get(
      baseUri(path: kAPIOrderListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderEntity>(
      response,
      kAPIOrderListURL,
      (dataMap) => MultiOrderEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<MultiOrderEntity>> getListOrdersByStatus(String status) async {
    final response = await _client.get(
      baseUri(path: '$kAPIOrderListByStatusURL/$status'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<MultiOrderEntity>(
      response,
      '$kAPIOrderListByStatusURL/$status',
      (dataMap) => MultiOrderEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createByProductVariant(int productVariantId, int quantity) async {
    final body = {
      productVariantId.toString(): quantity.toString(),
    };

    final response = await _client.post(
      baseUri(path: kAPIOrderCreateByProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderCreateByProductVariantURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> createUpdateWithVariant(PlaceOrderWithVariantParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderCreateUpdateWithProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderCreateUpdateWithProductVariantURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> placeOrderWithVariant(PlaceOrderWithVariantParam params) async {
    final response = await _client.post(
      baseUri(path: kAPIOrderAddWithProductVariantURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: params.toJson(),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      kAPIOrderAddWithProductVariantURL,
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<OrderDetailEntity>> getOrderDetail(String orderId) async {
    final response = await _client.get(
      baseUri(path: '$kAPIOrderDetailURL/$orderId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<OrderDetailEntity>(
      response,
      '$kAPIOrderDetailURL/$orderId',
      (dataMap) => OrderDetailEntity.fromMap(dataMap),
    );
  }
}
