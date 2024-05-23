import 'package:dio/dio.dart';
import 'package:flutter_vtv/core/constants/customer_api.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/wallet.dart';

abstract class PaymentDataSource {
  //# vn-pay-controller
  Future<SuccessResponse<String>> createPaymentForSingleOrder(String orderId);
  Future<SuccessResponse<String>> createPaymentForMultiOrder(List<String> orderIds);

  //# wallet-controller
  // /api/customer/wallet/get
  Future<SuccessResponse<WalletEntity>> getWalletTransactionHistory();
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final Dio _dio;

  PaymentDataSourceImpl(this._dio);
  @override
  Future<SuccessResponse<String>> createPaymentForSingleOrder(String orderId) async {
    final url = uriBuilder(path: '$kAPIVnPayCreatePaymentURL/$orderId');

    final response = await _dio.postUri(url);

    return handleDioResponse<String, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => jsonMap['url'] as String,
    );
  }

  @override
  Future<SuccessResponse<String>> createPaymentForMultiOrder(List<String> orderIds) async {
    final url = uriBuilder(path: kAPIVnPayCreatePaymentMultipleOrderURL);

    final response = await _dio.postUri(url, data: orderIds);

    return handleDioResponse<String, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => jsonMap['url'] as String,
    );
  }

  @override
  Future<SuccessResponse<WalletEntity>> getWalletTransactionHistory() async {
    final url = uriBuilder(path: kAPIWalletGetURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<WalletEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => WalletEntity.fromMap(jsonMap['walletDTO']),
    );
  }
}
