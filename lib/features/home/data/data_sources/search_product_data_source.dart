import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../core/constants/customer_api.dart';
import '../../domain/entities/search_history_resp.dart';

abstract class SearchProductDataSource {
  //# search-product-controller
  //* search in home page
  Future<SuccessResponse<ProductPageResp>> searchProductSort(int page, int size, String keyword, String sort);
  Future<SuccessResponse<ProductPageResp>> searchProductPriceRangeSort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice);

  //* search in shop
  Future<SuccessResponse<ProductPageResp>> searchProductShopSort(
      int page, int size, String keyword, String sort, int shopId);
  Future<SuccessResponse<ProductPageResp>> searchProductShopPriceRangeSort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice, int shopId);

  //# search-history-controller
  Future<SuccessResponse> searchHistoryAdd(String query);
  Future<SuccessResponse<SearchHistoryResp>> searchHistoryGetPage(int page, int size);
  Future<SuccessResponse> searchHistoryDelete(String searchHistoryId);
}

class SearchProductDataSourceImpl implements SearchProductDataSource {
  final Dio _dio;

  SearchProductDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<ProductPageResp>> searchProductSort(int page, int size, String keyword, String sort) async {
    final url = uriBuilder(
      path: kAPISearchProductSortURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'search': keyword,
        'sort': sort,
      },
    );
    // send request
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );

    // // decode response using utf8
    // final utf8BodyMap = utf8.decode(response.bodyBytes);
    // final decodedBody = jsonDecode(utf8BodyMap);

    // // handle response
    // if (response.statusCode == 200) {
    //   final result = ProductDTO.fromMap(decodedBody);
    //   return SuccessResponse<ProductDTO>(
    //     result,
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //   );
    // } else {
    //   throwResponseException(
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //     url: kAPIGetSearchProductURL,
    //   );
    // }
  }

  @override
  Future<SuccessResponse<ProductPageResp>> searchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  ) async {
    final url = uriBuilder(
      path: kAPISearchProductPriceRangeSortURL,
      queryParameters: {
        'page': page,
        'size': size,
        'search': keyword,
        'sort': sort,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    // send request
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );

    // // decode response using utf8
    // final utf8BodyMap = utf8.decode(response.bodyBytes);
    // final decodedBody = jsonDecode(utf8BodyMap);

    // // handle response
    // if (response.statusCode == 200) {
    //   final result = ProductDTO.fromMap(decodedBody);
    //   return SuccessResponse<ProductDTO>(
    //     result,
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //   );
    // } else {
    //   throwResponseException(
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //     url: kAPIGetSearchProductPriceRangeSortURL,
    //   );
    // }
  }

  @override
  Future<SuccessResponse<ProductPageResp>> searchProductShopPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
    int shopId,
  ) async {
    final url = uriBuilder(
      path: kAPISearchProductShopPriceRangeSortURL,
      queryParameters: {
        'page': page,
        'size': size,
        'search': keyword,
        'sort': sort,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      }.map((key, value) => MapEntry(key, value.toString())),
      pathVariables: {
        'shopId': shopId.toString(),
      },
    );

    // send request
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> searchProductShopSort(
    int page,
    int size,
    String keyword,
    String sort,
    int shopId,
  ) async {
    final url = uriBuilder(
      path: kAPISearchProductShopSortURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'search': keyword,
        'sort': sort,
      },
      pathVariables: {
        'shopId': shopId.toString(),
      },
    );

    // send request
    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<Object?>> searchHistoryAdd(String query) async {
    final url = uriBuilder(path: kAPISearchHistoryAddURL);
    final response = await _dio.postUri(url, data: query);

    return handleDioResponse<Object?, Map<String, dynamic>>(response, url, hasData: false);
  }

  @override
  Future<SuccessResponse<Object?>> searchHistoryDelete(String searchHistoryId) async {
    final url = uriBuilder(path: kAPISearchHistoryDeleteURL);

    final response = await _dio.deleteUri(url, data: searchHistoryId);

    return handleDioResponse<Object?, Map<String, dynamic>>(response, url, hasData: false);
  }

  @override
  Future<SuccessResponse<SearchHistoryResp>> searchHistoryGetPage(int page, int size) async {
    final url = uriBuilder(path: kAPISearchHistoryGetPageURL, pathVariables: {
      'page': page.toString(),
      'size': size.toString(),
    });

    final response = await _dio.getUri(url);

    return handleDioResponse<SearchHistoryResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => SearchHistoryResp.fromMap(jsonMap),
    );
  }
}
