import 'package:dio/dio.dart';
import 'package:flutter_vtv/core/constants/customer_api.dart';
import 'package:vtv_common/core.dart';

abstract class PaymentDataSource {
  //# vn-pay-controller
  Future<SuccessResponse<String>> createPaymentForSingleOrder(String orderId);
  Future<SuccessResponse<String>> createPaymentForMultiOrder(List<String> orderIds);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final Dio _dio;

  PaymentDataSourceImpl(this._dio);
  @override
  Future<SuccessResponse<String>> createPaymentForSingleOrder(String orderId) async {
    final url = baseUri(path: '$kAPIVnPayCreatePaymentURL/$orderId');

    final response = await _dio.postUri(url);

    return handleDioResponse<String, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => jsonMap['url'] as String,
    );
  }

  @override
  Future<SuccessResponse<String>> createPaymentForMultiOrder(List<String> orderIds) async {
    final url = baseUri(path: kAPIVnPayCreatePaymentMultipleOrderURL);

    final response = await _dio.postUri(url, data: orderIds);

    return handleDioResponse<String, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => jsonMap['url'] as String,
    );
  }
}
