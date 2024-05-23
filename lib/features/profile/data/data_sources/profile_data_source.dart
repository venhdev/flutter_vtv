import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../core/constants/customer_api.dart';

abstract class ProfileDataSource {
  //! address-controller
  Future<SuccessResponse> updateAddressStatus(int addressId);
  Future<SuccessResponse<List<AddressEntity>>> getAllAddress();
  Future<SuccessResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
  Future<SuccessResponse<AddressEntity>> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);

  //# loyalty-point-controller
  Future<SuccessResponse<LoyaltyPointEntity>> getLoyaltyPoint();

  //# loyalty-point-history-controller
  Future<SuccessResponse<List<LoyaltyPointHistoryEntity>>> getLoyaltyPointHistory(int loyaltyPointId);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final http.Client _client;
  final dio.Dio _dio;
  final SecureStorageHelper _secureStorageHelper;

  ProfileDataSourceImpl(this._client, this._secureStorageHelper, this._dio);
  @override
  Future<SuccessResponse<List<AddressEntity>>> getAllAddress() async {
    final url = uriBuilder(path: kAPIAddressAllURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<AddressEntity>>(
      response,
      url,
      (data) => (data['addressDTOs'] as List<dynamic>)
          .map(
            (address) => AddressEntity.fromMap(address),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
    final url = uriBuilder(path: kAPIAddressAddURL);
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(addOrUpdateAddressParam.toJson()),
    );

    // return handleResponseNoData(
    //   response,
    //   kAPIAddressAddURL,
    // );
    return handleResponseWithData<AddressEntity>(
      response,
      url,
      (data) => AddressEntity.fromMap(data['addressDTO']),
    );
  }

  @override
  Future<SuccessResponse> updateAddressStatus(int addressId) async {
    final body = {
      "username": await _secureStorageHelper.username,
      "addressId": addressId,
      "status": "ACTIVE",
    };

    final url = uriBuilder(path: kAPIAddressUpdateStatusURL);

    final response = await _client.patch(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }

  @override
  Future<SuccessResponse<AddressEntity>> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
    final url = uriBuilder(path: kAPIAddressUpdateURL);
    final response = await _client.put(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(addOrUpdateAddressParam.toJson()),
    );

    return handleResponseWithData<AddressEntity>(
      response,
      url,
      (data) => AddressEntity.fromMap(data['addressDTO']),
    );
  }

  @override
  Future<SuccessResponse<LoyaltyPointEntity>> getLoyaltyPoint() async {
    final url = uriBuilder(path: kAPILoyaltyPointGetURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<LoyaltyPointEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => LoyaltyPointEntity.fromMap(jsonMap['loyaltyPointDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<LoyaltyPointHistoryEntity>>> getLoyaltyPointHistory(int loyaltyPointId) async {
    final url = uriBuilder(path: '$kAPILoyaltyPointHistoryGetListURL/$loyaltyPointId');

    final response = await _dio.getUri(url);

    return handleDioResponse<List<LoyaltyPointHistoryEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['loyaltyPointHistoryDTOs'] as List<dynamic>)
          .map(
            (loyaltyPointHistory) => LoyaltyPointHistoryEntity.fromMap(loyaltyPointHistory),
          )
          .toList(),
    );
  }
}
