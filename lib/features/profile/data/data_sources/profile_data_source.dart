import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

abstract class ProfileDataSource {
  //! location: ward-controller, province-controller, district-controller, ward-controller
  Future<DataResponse<List<ProvinceEntity>>> getProvinces();
  Future<DataResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<DataResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<DataResponse<String>> getFullAddressByWardCode(String wardCode);

  //! address-controller
  Future<SuccessResponse> updateAddressStatus(int addressId);
  Future<DataResponse<List<AddressEntity>>> getAllAddress();
  Future<DataResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
  Future<DataResponse<AddressEntity>> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  ProfileDataSourceImpl(this._client, this._secureStorageHelper);
  @override
  Future<DataResponse<List<AddressEntity>>> getAllAddress() async {
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
  Future<DataResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode) async {
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
  Future<DataResponse<String>> getFullAddressByWardCode(String wardCode) async {
    throw UnimplementedError();
  }

  @override
  Future<DataResponse<List<ProvinceEntity>>> getProvinces() async {
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
  Future<DataResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode) async {
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
  Future<DataResponse<AddressEntity>> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
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
  Future<DataResponse<AddressEntity>> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async{
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
}
