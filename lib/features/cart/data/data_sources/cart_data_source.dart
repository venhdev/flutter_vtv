import 'dart:convert';
import 'dart:developer';

import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/cart/domain/dto/add_address_param.dart';
import 'package:flutter_vtv/features/cart/domain/dto/address_dto.dart';
import 'package:flutter_vtv/features/cart/domain/entities/district_entity.dart';
import 'package:flutter_vtv/features/cart/domain/entities/province_entity.dart';
import 'package:flutter_vtv/features/cart/domain/entities/ward_entity.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/dto/cart_resp.dart';

abstract class CartDataSource {
  Future<DataResponse<CartResp>> getCarts();
  Future<SuccessResponse> addToCart(int productVariantId, int quantity);
  Future<SuccessResponse> updateCart(String cartId, int quantity);
  Future<SuccessResponse> deleteToCart(String cartId);
  Future<SuccessResponse> deleteToCartByShopId(String shopId);

  // location
  Future<DataResponse<List<ProvinceEntity>>> getProvinces();
  Future<DataResponse<List<DistrictEntity>>> getDistrictsByProvinceCode(String provinceCode);
  Future<DataResponse<List<WardEntity>>> getWardsByDistrictCode(String districtCode);
  Future<DataResponse<String>> getFullAddressByWardCode(String wardCode);

  // address
  Future<DataResponse<List<AddressDTO>>> getAllAddress();
  Future<SuccessResponse> addAddress(AddAddressParam addAddressParam);
}

class CartDataSourceImpl extends CartDataSource {
  CartDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<CartResp>> getCarts() async {
    final response = await _client.get(
      baseUri(path: kAPICartGetListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<CartResp>(
      response,
      kAPICartGetListURL,
      (data) => CartResp.fromMap(data),
    );
  }

  @override
  Future<SuccessResponse> addToCart(int productVariantId, int quantity) async {
    final body = {
      'username': await _secureStorageHelper.username,
      'productVariantId': productVariantId.toString(),
      'quantity': quantity.toString(),
    };

    final response = await _client.post(
      baseUri(path: kAPICartAddURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(
      response,
      kAPICartGetListURL,
    );
  }

  @override
  Future<SuccessResponse> deleteToCart(String cartId) async {
    final response = await _client.delete(
      baseUri(path: '$kAPICartDeleteURL/$cartId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      kAPICartDeleteURL,
    );
  }

  @override
  Future<SuccessResponse> deleteToCartByShopId(String shopId) async {
    final response = await _client.delete(
      baseUri(path: '$kAPICartDeleteByShopIdURL/$shopId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      kAPICartDeleteByShopIdURL,
    );
  }

  @override
  Future<SuccessResponse> updateCart(String cartId, int quantity) async {
    final response = await _client.put(
      baseUri(
        path: '$kAPICartUpdateURL/$cartId',
        queryParameters: {
          'quantity': quantity.toString(),
        },
      ),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      // body: jsonEncode({
      //   'quantity': quantity,
      // }),
    );

    return handleResponseNoData(
      response,
      kAPICartUpdateURL,
    );
  }

  @override
  Future<DataResponse<List<AddressDTO>>> getAllAddress() async {
    final response = await _client.get(
      baseUri(path: kAPIAddressAllURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<AddressDTO>>(
      response,
      kAPIAddressAllURL,
      (data) => (data['addressDTOs'] as List<dynamic>)
          .map(
            (address) => AddressDTO.fromMap(address),
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
  Future<SuccessResponse> addAddress(AddAddressParam addAddressParam) async {
    log('addAddressParam: ${addAddressParam.toJson()}');
    
    final response = await _client.post(
      baseUri(path: kAPIAddressAddURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(addAddressParam.toJson()),
    );

    return handleResponseNoData(
      response,
      kAPIAddressAddURL,
    );
  }
}
