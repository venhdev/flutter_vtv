import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

abstract class ProfileDataSource {
  //! location
  Future<DataResponse<List<ProvinceEntity>>> getProvinces();
  Future<DataResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<DataResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<DataResponse<String>> getFullAddressByWardCode(String wardCode);
  Future<SuccessResponse> updateAddressStatus(int addressId);

  //! address
  Future<DataResponse<List<AddressEntity>>> getAllAddress();
  Future<DataResponse<AddressEntity>> addAddress(AddAddressParam addAddressParam);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  ProfileDataSourceImpl(this._client, this._secureStorageHelper);
  @override
  Future<DataResponse<List<AddressEntity>>> getAllAddress() async {
    final response = await _client.get(
      baseUri(path: kAPIAddressAllURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<AddressEntity>>(
      response,
      kAPIAddressAllURL,
      (data) => (data['addressDTOs'] as List<dynamic>)
          .map(
            (address) => AddressEntity.fromMap(address),
          )
          .toList(),
    );
  }

  @override
  Future<DataResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode) async {
    final response = await _client.get(
      baseUri(path: '$kAPILocationDistrictGetAllByProvinceCodeURL/$provinceCode'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<DistrictEntity>>(
      response,
      kAPILocationDistrictGetAllByProvinceCodeURL,
      (data) => (data['districtDTOs'] as List<dynamic>)
          .map(
            (district) => DistrictEntity.fromMap(district),
          )
          .toList(),
    );
  }

  @override
  Future<DataResponse<String>> getFullAddressByWardCode(String wardCode) async {
    throw UnimplementedError();
  }

  @override
  Future<DataResponse<List<ProvinceEntity>>> getProvinces() async {
    final response = await _client.get(
      baseUri(path: kAPILocationProvinceGetAllURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<ProvinceEntity>>(
      response,
      kAPILocationProvinceGetAllURL,
      (data) => (data['provinceDTOs'] as List<dynamic>)
          .map(
            (province) => ProvinceEntity.fromMap(province),
          )
          .toList(),
    );
  }

  @override
  Future<DataResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode) async {
    final response = await _client.get(
      baseUri(path: '$kAPILocationWardGetAllByDistrictCodeURL/$districtCode'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<WardEntity>>(
      response,
      kAPILocationWardGetAllByDistrictCodeURL,
      (data) => (data['wardDTOs'] as List<dynamic>)
          .map(
            (ward) => WardEntity.fromMap(ward),
          )
          .toList(),
    );
  }

  @override
  Future<DataResponse<AddressEntity>> addAddress(AddAddressParam addAddressParam) async {
    final response = await _client.post(
      baseUri(path: kAPIAddressAddURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(addAddressParam.toJson()),
    );

    // return handleResponseNoData(
    //   response,
    //   kAPIAddressAddURL,
    // );
    return handleResponseWithData<AddressEntity>(
      response,
      kAPIAddressAddURL,
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

    final response = await _client.patch(
      baseUri(path: kAPIAddressUpdateStatusURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(
      response,
      kAPIAddressUpdateStatusURL,
    );
  }
}
