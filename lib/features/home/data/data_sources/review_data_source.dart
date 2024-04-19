import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../core/constants/customer_apis.dart';
import '../../../order/domain/dto/review_param.dart';

abstract class ReviewDataSource {
  //# review-controller (guest)
  Future<SuccessResponse<ReviewResp>> getReviewProduct(int productId);

  //# review-customer-controller (customer)
  Future<SuccessResponse<ReviewEntity>> addReview(ReviewParam params);
  Future<SuccessResponse<bool>> checkExistReview(String orderItemId);
  Future<SuccessResponse> deleteReview(String reviewId);
  Future<SuccessResponse<ReviewEntity>> getReviewDetail(String orderItemId);
}

class ReviewDataSourceImpl implements ReviewDataSource {
  ReviewDataSourceImpl(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorageHelper _secureStorage;

  @override
  Future<SuccessResponse<ReviewResp>> getReviewProduct(int productId) async {
    final url = baseUri(
      path: '$kAPIReviewProductURL/$productId',
    );
    final response = await _dio.getUri(
      url,
      options: Options(headers: baseHttpHeaders()),
    );

    return handleDioResponse<ReviewResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ReviewEntity>> addReview(ReviewParam params) async {
    // final url = baseUri(
    //   path: kAPIReviewAddURL,
    // );
    // final response = await _dio.postUri(
    //   url,
    //   data: params.toMap(),
    //   options: Options(headers: baseHttpHeaders()),
    // );

    FormData formData = FormData.fromMap({
      'content': params.content,
      'rating': params.rating,
      'orderItemId': params.orderItemId,
      if (params.imagePath != null)
        'image': await MultipartFile.fromFile(
          params.imagePath!,
          filename: params.imagePath!.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      'hasImage': params.hasImage,
    });

    final url = baseUri(
      path: kAPIReviewAddURL,
    );

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Accept': '*/*',
          'Authorization': 'Bearer ${await _secureStorage.accessToken}',
        },
      ),
    );

    log('response: ${response.data}');

    return handleDioResponse<ReviewEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewEntity.fromMap(jsonMap['reviewDTO']),
    );
  }

  @override
  Future<SuccessResponse<bool>> checkExistReview(String orderItemId) async {
    final url = baseUri(
      path: '$kAPIReviewExistByOrderItemURL/$orderItemId',
    );
    final response = await _dio.getUri(
      url,
      options: Options(headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken)),
    );

    return handleDioResponse<bool, bool>(
      response,
      url,
      parse: (data) => data,
    );
  }

  @override
  Future<SuccessResponse> deleteReview(String reviewId) async {
    final url = baseUri(
      path: '$kAPIReviewDeleteURL/$reviewId',
    );
    final response = await _dio.patchUri(
      url,
      options: Options(headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken)),
    );

    return handleDioResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse<ReviewEntity>> getReviewDetail(String orderItemId) async {
    final url = baseUri(
      path: '$kAPIReviewDetailByOrderItemURL/$orderItemId',
    );
    final response = await _dio.getUri(
      url,
      options: Options(headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken)),
    );

    return handleDioResponse<ReviewEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewEntity.fromMap(jsonMap['reviewDTO']),
    );
  }
}
