import 'package:http/http.dart' as http show Client;
import '../../../../core/network/base_response.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/response/product_resp.dart';

abstract class SearchProductDataSource {
  Future<DataResponse<ProductResp>> searchProductSort(int page, int size, String keyword, String sort);

  Future<DataResponse<ProductResp>> searchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  );
}

class SearchProductDataSourceImpl implements SearchProductDataSource {
  final http.Client _client;

  SearchProductDataSourceImpl(this._client);

  @override
  Future<DataResponse<ProductResp>> searchProductSort(int page, int size, String keyword, String sort) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPISearchProductSortURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'search': keyword,
          'sort': sort,
        },
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData(
      response,
      kAPISearchProductSortURL,
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
    //     url: kAPIGetSearchProductURL,
    //   );
    // }
  }

  @override
  Future<DataResponse<ProductResp>> searchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  ) async {
    // send request
    final response = await _client.get(
      baseUri(
        path: kAPIGetSearchProductPriceRangeSortURL,
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

    return handleResponseWithData(
      response,
      kAPIGetSearchProductPriceRangeSortURL,
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
    //     url: kAPIGetSearchProductPriceRangeSortURL,
    //   );
    // }
  }
}
