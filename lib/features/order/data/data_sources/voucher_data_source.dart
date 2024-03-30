import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/entities/voucher_entity.dart';

abstract class VoucherDataSource {
  Future<DataResponse<List<VoucherEntity>>> listAll();
  Future<DataResponse<List<VoucherEntity>>> listOnSystem();
  Future<DataResponse<List<VoucherEntity>>> listOnShop(String shopId);
}

class VoucherDataSourceImpl extends VoucherDataSource {
  VoucherDataSourceImpl(
    this._client,
    // this._secureStorageHelper,
  );

  // final SecureStorageHelper _secureStorageHelper;
  final http.Client _client;

  @override
  Future<DataResponse<List<VoucherEntity>>> listAll() async {
    final response = await _client.get(
      baseUri(path: kAPIVoucherListAllURL),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      kAPIVoucherListAllURL,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<DataResponse<List<VoucherEntity>>> listOnShop(String shopId) async {
    final response = await _client.get(
      baseUri(path: '$kAPIVoucherListOnShopURL/$shopId'),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      kAPIVoucherListOnShopURL,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<DataResponse<List<VoucherEntity>>> listOnSystem() async {
    final response = await _client.get(
      baseUri(path: kAPIVoucherListOnSystemURL),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      kAPIVoucherListOnSystemURL,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }
}
