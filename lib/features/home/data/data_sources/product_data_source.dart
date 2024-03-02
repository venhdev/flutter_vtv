import 'dart:convert';

import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/product_dto.dart';

abstract class ProductDataSource {
  Future<DataResponse<ProductDTO>> getSuggestionProductsRandomly(int page, int size);
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

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = ProductDTO.fromMap(decodedBody);
      return DataResponse<ProductDTO>(
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
