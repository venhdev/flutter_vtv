import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/constants/customer_api.dart';

abstract class VoucherDataSource {
  Future<SuccessResponse<List<VoucherEntity>>> listAll();
  Future<SuccessResponse<List<VoucherEntity>>> listOnSystem();
  Future<SuccessResponse<List<VoucherEntity>>> listOnShop(int shopId);

  //# customer-voucher-controller
  // const String kAPICustomerVoucherSaveURL = '/customer/voucher/save'; // POST /{voucherId}
  Future<SuccessResponse<VoucherEntity>> customerVoucherSave(int voucherId);
  // const String kAPICustomerVoucherListURL = '/customer/voucher/list'; // GET
  Future<SuccessResponse<List<VoucherEntity>>> customerVoucherList();
  // const String kAPICustomerVoucherDeleteURL = '/customer/voucher/delete'; // DELETE /{voucherId}
  Future<SuccessResponse<VoucherEntity>> customerVoucherDelete(int voucherId);
}

class VoucherDataSourceImpl extends VoucherDataSource {
  VoucherDataSourceImpl(
    this._dio,
    // this._secureStorageHelper,
  );

  // final SecureStorageHelper _secureStorageHelper;
  final Dio _dio;

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listAll() async {
    final url = baseUri(path: kAPIVoucherListAllURL);
    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => VoucherEntity.fromList(jsonMap['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listOnShop(int shopId) async {
    final url = baseUri(path: '$kAPIVoucherListOnShopURL/$shopId');
    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listOnSystem() async {
    final url = baseUri(path: kAPIVoucherListOnSystemURL);
    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<VoucherEntity>> customerVoucherDelete(int voucherId) async {
    final url = baseUri(path: '$kAPICustomerVoucherDeleteURL/$voucherId');

    final response = await _dio.deleteUri(url);

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => VoucherEntity.fromMap(data['voucherDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> customerVoucherList() async {
    final url = baseUri(path: kAPICustomerVoucherListURL);
    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<VoucherEntity>> customerVoucherSave(int voucherId) async {
    final url = baseUri(path: '$kAPICustomerVoucherSaveURL/$voucherId');
    final response = await _dio.postUri(url);

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (data) => VoucherEntity.fromMap(data['voucherDTO']),
    );
  }
}
