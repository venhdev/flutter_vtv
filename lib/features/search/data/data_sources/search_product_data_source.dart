import 'dart:convert';

import 'package:flutter_vtv/features/search/domain/response/page_product_response.dart';
import 'package:http/http.dart' as http show Client;
import '../../../../core/network/base_response.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';

abstract class SearchProductDataSource {
  Future<DataResponse<PageProductResponse>> searchPageProductBySort(
      int page, int size, String keyword, String sort);

  Future<DataResponse<PageProductResponse>> searchAndPriceRangePageProductBySort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice);
}




class SearchProductDataSourceImpl implements SearchProductDataSource {
  final http.Client _client;

  SearchProductDataSourceImpl(this._client);

  @override
  Future<DataResponse<PageProductResponse>> searchPageProductBySort(
      int page, int size, String keyword, String sort) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPIGetSearchProductURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'search': keyword.toString(),
          'sort': sort.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = PageProductResponse.fromMap(decodedBody);
      return DataResponse<PageProductResponse>(
        result,
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPIAuthLoginURL,
      );
    }
  }

  @override
  Future<DataResponse<PageProductResponse>> searchAndPriceRangePageProductBySort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPIGetSearchPriceRangeProductURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'search': keyword.toString(),
          'sort': sort.toString(),
          'minPrice': minPrice.toString(),
          'maxPrice': maxPrice.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = PageProductResponse.fromMap(decodedBody);
      return DataResponse<PageProductResponse>(
        result,
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPIAuthLoginURL,
      );
    }
  }
}
