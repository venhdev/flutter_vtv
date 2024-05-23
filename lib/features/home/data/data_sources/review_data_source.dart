import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../core/constants/customer_api.dart';
import '../../../order/domain/dto/review_param.dart';
import '../../domain/dto/comment_param.dart';

abstract class ReviewDataSource {
  //! Review Section
  //# review-controller (guest)
  Future<SuccessResponse<ReviewResp>> getProductReviews(int productId);
  Future<SuccessResponse<ReviewEntity>> getReviewDetailByReviewId(String reviewId);

  //# review-customer-controller (customer)
  Future<SuccessResponse<ReviewEntity>> addReview(ReviewParam params);
  Future<SuccessResponse<bool>> checkExistReview(String orderItemId);
  Future<SuccessResponse> deleteReview(String reviewId);
  Future<SuccessResponse<ReviewEntity>> getReviewDetailByOrderItemId(String orderItemId);

  //! Comment Section
  //# comment-controller
  Future<SuccessResponse<List<CommentEntity>>> getReviewComments(String reviewId); //uuid

  //# comment-customer-controller
  Future<SuccessResponse<CommentEntity>> addCustomerComment(CommentParam param);
  Future<SuccessResponse> deleteCustomerComment(String commentId); //uuid
}

class ReviewDataSourceImpl implements ReviewDataSource {
  ReviewDataSourceImpl(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorageHelper _secureStorage;

  @override
  Future<SuccessResponse<ReviewResp>> getProductReviews(int productId) async {
    final url = uriBuilder(
      path: '$kAPIReviewProductURL/$productId',
    );
    final response = await _dio.getUri(url);

    return handleDioResponse<ReviewResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ReviewEntity>> addReview(ReviewParam params) async {
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

    final url = uriBuilder(path: kAPIReviewAddURL);

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Accept': '*/*',
        },
      ),
    );

    return handleDioResponse<ReviewEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewEntity.fromMap(jsonMap['reviewDTO']),
    );
  }

  @override
  Future<SuccessResponse<bool>> checkExistReview(String orderItemId) async {
    final url = uriBuilder(
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
    final url = uriBuilder(
      path: '$kAPIReviewDeleteURL/$reviewId',
    );
    final response = await _dio.deleteUri(
      url,
    );

    return handleDioResponseNoData(response, url);
  }

  @override
  Future<SuccessResponse<ReviewEntity>> getReviewDetailByOrderItemId(String orderItemId) async {
    final url = uriBuilder(
      path: '$kAPIReviewDetailByOrderItemURL/$orderItemId',
    );
    final response = await _dio.getUri(url);

    return handleDioResponse<ReviewEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewEntity.fromMap(jsonMap['reviewDTO']),
    );
  }

  @override
  Future<SuccessResponse<CommentEntity>> addCustomerComment(CommentParam param) async {
    final url = uriBuilder(path: kAPICommentAddURL);
    final response = await _dio.postUri(
      url,
      data: param.toMap(),
    );

    return handleDioResponse<CommentEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => CommentEntity.fromMap(jsonMap['commentDTO']),
    );
  }

  @override
  Future<SuccessResponse<Object?>> deleteCustomerComment(String commentId) async {
    final url = uriBuilder(path: '$kAPICommentDeleteURL/$commentId');
    final response = await _dio.patchUri(url);

    return handleDioResponse<Object?, Map<String, dynamic>>(
      response,
      url,
      hasData: false,
    );
  }

  @override
  Future<SuccessResponse<List<CommentEntity>>> getReviewComments(String reviewId) async {
    // OK_TODO: implement getReviewComments (API not available)
    final url = uriBuilder(path: '$kAPICommentGetURL/$reviewId');

    final response = await _dio.getUri(url);

    return handleDioResponse<List<CommentEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonList) => (jsonList['commentDTOs'] as List)
          .map(
            (jsonMap) => CommentEntity.fromMap(jsonMap),
          )
          .toList(),
    );
  }

  @override
  Future<SuccessResponse<ReviewEntity>> getReviewDetailByReviewId(String reviewId) async {
    final url = uriBuilder(path: '$kAPIReviewDetailURL/$reviewId');

    final response = await _dio.getUri(url);

    return handleDioResponse<ReviewEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ReviewEntity.fromMap(jsonMap['reviewDTO']),
    );
  }
}
