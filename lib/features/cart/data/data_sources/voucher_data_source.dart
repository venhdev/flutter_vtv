import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/entities/voucher_entity.dart';

abstract class VoucherDataSource {
  Future<DataResponse<List<VoucherEntity>>> listAll();
}

class VoucherDataSourceImpl extends VoucherDataSource {
  VoucherDataSourceImpl(this._client, this._secureStorageHelper);

  final SecureStorageHelper _secureStorageHelper;
  final http.Client _client;

  @override
  Future<DataResponse<List<VoucherEntity>>> listAll() async {
    final response = await _client.get(
      baseUri(path: kAPIVoucherListAllURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<VoucherEntity>>(
      response,
      kAPIVoucherListAllURL,
      (data) => VoucherEntity.fromList(data['voucherDTOs'] as List<dynamic>),
    );
  }
}
