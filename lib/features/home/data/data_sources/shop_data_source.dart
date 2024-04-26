import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/shop.dart';

import '../../../../core/constants/customer_api.dart';

abstract class ShopDataSource {
  //# shop-detail-controller
  Future<SuccessResponse<int>> countShopFollowed(int shopId);
  Future<SuccessResponse<ShopDetailResp>> getShopDetailById(int shopId);

  //# followed-shop-controller
  Future<SuccessResponse<FollowedShopEntity>> followedShopAdd(int shopId);
  Future<SuccessResponse<List<FollowedShopEntity>>> followedShopList();
  Future<SuccessResponse> followedShopDelete(int followedShopId);
}

class ShopDataSourceImpl implements ShopDataSource {
  final Dio _dio;

  ShopDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<int>> countShopFollowed(int shopId) async {
    // OK:REVIEW why need accessToken here?
    final url = baseUri(path: '$kAPIShopCountFollowedURL/$shopId');
    final response = await _dio.getUri(
      url,
    );

    return handleDioResponse<int, int>(
      response,
      url,
      parse: (count) => count,
    );
  }

  @override
  Future<SuccessResponse<FollowedShopEntity>> followedShopAdd(int shopId) async {
    final url = baseUri(
      path: kAPIFollowedShopAddURL,
      queryParameters: {'shopId': shopId.toString()},
    );

    final response = await _dio.postUri(
      url,
    );

    return handleDioResponse<FollowedShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => FollowedShopEntity.fromMap(jsonMap['followedShopDTO']),
    );
  }

  @override
  Future<SuccessResponse> followedShopDelete(int followedShopId) async {
    final url = baseUri(path: '$kAPIFollowedShopDeleteURL/$followedShopId');

    final response = await _dio.deleteUri(
      url,
    );

    return handleDioResponse<Object?, Map<String, dynamic>>(
      response,
      url,
      hasData: false,
    );
  }

  @override
  Future<SuccessResponse<List<FollowedShopEntity>>> followedShopList() async {
    final url = baseUri(path: kAPIFollowedShopListURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<List<FollowedShopEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonList) => (jsonList['followedShopDTOs'] as List)
          .map(
            (jsonMap) => FollowedShopEntity.fromMap(jsonMap),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<ShopDetailResp>> getShopDetailById(int shopId) async {
    final url = baseUri(path: '$kAPIShopURL/$shopId');

    final response = await _dio.getUri(url);

    return handleDioResponse<ShopDetailResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopDetailResp.fromMap(jsonMap),
    );
  }
}
