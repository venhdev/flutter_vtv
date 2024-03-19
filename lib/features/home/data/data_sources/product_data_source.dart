import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/response/product_resp.dart';

abstract class ProductDataSource {
  Future<DataResponse<ProductResp>> getSuggestionProductsRandomly(
      int page, int size);

  Future<DataResponse<ProductResp>> getProductFilter(
      int page, int size, String sortType);

  Future<DataResponse<ProductResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  });
}

class ProductDataSourceImpl implements ProductDataSource {
  final http.Client _client;

  ProductDataSourceImpl(this._client);
  @override
  Future<DataResponse<ProductResp>> getSuggestionProductsRandomly(
      int page, int size) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPISuggestionProductURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductResp>(
      response,
      kAPISuggestionProductURL,
      (jsonMap) => ProductResp.fromMap(jsonMap),
    );

    // // decode response using utf8
    // final utf8BodyMap = utf8.decode(response.bodyBytes);
    // final decodedBody = jsonDecode(utf8BodyMap);

    // // handle response
    // if (response.statusCode == 200) {
    //   final result = ProductDTO.fromMap(decodedBody);
    //   return DataResponse<ProductDTO>(
    //     result,
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //   );
    // } else {
    //   throwResponseException(
    //     code: response.statusCode,
    //     message: decodedBody['message'],
    //     url: kAPIAuthLoginURL,
    //   );
    // }
  }

  @override
  Future<DataResponse<ProductResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  }) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: '$kAPIProductFilterPriceRangeURL/$filter',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'minPrice': minPrice.toString(),
          'maxPrice': maxPrice.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductResp>(
      response,
      kAPIProductFilterPriceRangeURL,
      (jsonMap) => ProductResp.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<ProductResp>> getProductFilter(
      int page, int size, String sortType) async {
    final response = await _client.get(
      baseUri(
        path: '$kAPIProductFilterURL/$sortType',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductResp>(
      response,
      kAPIProductFilterURL,
      (jsonMap) => ProductResp.fromMap(jsonMap),
    );
  }
}
