import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../core/constants/customer_api.dart';

abstract class ProfileDataSource {
  //! location: ward-controller, province-controller, district-controller, ward-controller
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces();
  Future<SuccessResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<SuccessResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<SuccessResponse<String>> getFullAddressByWardCode(String wardCode);

  //! address-controller
  Future<SuccessResponse> updateAddressStatus(int addressId);
  Future<SuccessResponse<List<AddressEntity>>> getAllAddress();
  Future<SuccessResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
  Future<SuccessResponse<AddressEntity>> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);

  //# loyalty-point-controller
  Future<SuccessResponse<LoyaltyPointEntity>> getLoyaltyPoint();
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final http.Client _client;
  final dio.Dio _dio;
  final SecureStorageHelper _secureStorageHelper;

  ProfileDataSourceImpl(this._client, this._secureStorageHelper, this._dio);
  @override
  Future<SuccessResponse<List<AddressEntity>>> getAllAddress() async {
    final url = baseUri(path: kAPIAddressAllURL);
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
  Future<SuccessResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode) async {
    final url = baseUri(path: '$kAPILocationDistrictGetAllByProvinceCodeURL/$provinceCode');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<DistrictEntity>>(
      response,
      url,
      (data) => (data['districtDTOs'] as List<dynamic>)
          .map(
            (district) => DistrictEntity.fromMap(district),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<String>> getFullAddressByWardCode(String wardCode) async {
    throw UnimplementedError();
  }

  @override
  Future<SuccessResponse<List<ProvinceEntity>>> getProvinces() async {
    final url = baseUri(path: kAPILocationProvinceGetAllURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<ProvinceEntity>>(
      response,
      url,
      (data) => (data['provinceDTOs'] as List<dynamic>)
          .map(
            (province) => ProvinceEntity.fromMap(province),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode) async {
    final url = baseUri(path: '$kAPILocationWardGetAllByDistrictCodeURL/$districtCode');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<WardEntity>>(
      response,
      url,
      (data) => (data['wardDTOs'] as List<dynamic>)
          .map(
            (ward) => WardEntity.fromMap(ward),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
    final url = baseUri(path: kAPIAddressAddURL);
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

    final url = baseUri(path: kAPIAddressUpdateStatusURL);

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
    final url = baseUri(path: kAPIAddressUpdateURL);
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
    final url = baseUri(path: kAPILoyaltyPointGetURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<LoyaltyPointEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => LoyaltyPointEntity.fromMap(jsonMap['loyaltyPointDTO']),
    );
  }
}
