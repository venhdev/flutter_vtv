import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

abstract class VoucherDataSource {
  Future<SuccessResponse<List<VoucherEntity>>> listAll();
  Future<SuccessResponse<List<VoucherEntity>>> listOnSystem();
  Future<SuccessResponse<List<VoucherEntity>>> listOnShop(String shopId);
}

class VoucherDataSourceImpl extends VoucherDataSource {
  VoucherDataSourceImpl(
    this._client,
    // this._secureStorageHelper,
  );

  // final SecureStorageHelper _secureStorageHelper;
  final http.Client _client;

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listAll() async {
    final url = baseUri(path: kAPIVoucherListAllURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      url,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listOnShop(String shopId) async {
    final url = baseUri(path: '$kAPIVoucherListOnShopURL/$shopId');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      url,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> listOnSystem() async {
    final url = baseUri(path: kAPIVoucherListOnSystemURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      url,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }
}
