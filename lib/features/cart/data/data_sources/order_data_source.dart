import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/order_resp.dart';

abstract class OrderDataSource {
  Future<DataResponse<OrderResp>> createOrderByCartIds(List<String> cartIds);
}

class OrderDataSourceImpl extends OrderDataSource {
  OrderDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<OrderResp>> createOrderByCartIds(List<String> cartIds) async {

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
}