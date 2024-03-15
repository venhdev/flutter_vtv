import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/product_dto.dart';

abstract class ProductDataSource {
  Future<DataResponse<ProductDTO>> getSuggestionProductsRandomly(int page, int size);

  Future<DataResponse<ProductDTO>> getProductFilter(int page, int size, String sortType);

  Future<DataResponse<ProductDTO>> getProductFilterByPriceRange({
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
  Future<DataResponse<ProductDTO>> getSuggestionProductsRandomly(int page, int size) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPIGetSuggestionProductURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductDTO>(
      response,
      kAPIGetSuggestionProductURL,
      (jsonMap) => ProductDTO.fromMap(jsonMap),
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
  Future<DataResponse<ProductDTO>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  }) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: '$kAPIGetProductFilterPriceRangeURL/$filter',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'minPrice': minPrice.toString(),
          'maxPrice': maxPrice.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductDTO>(
      response,
      kAPIGetProductFilterPriceRangeURL,
      (jsonMap) => ProductDTO.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<ProductDTO>> getProductFilter(int page, int size, String sortType) async {
    final response = await _client.get(
      baseUri(
        path: '$kAPIGetProductFilterURL/$sortType',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductDTO>(
      response,
      kAPIGetProductFilterURL,
      (jsonMap) => ProductDTO.fromMap(jsonMap),
    );
  }
}
