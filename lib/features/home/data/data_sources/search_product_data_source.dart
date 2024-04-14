import 'package:http/http.dart' as http show Client;
import 'package:vtv_common/vtv_common.dart';

abstract class SearchProductDataSource {
  Future<DataResponse<ProductPageResp>> searchProductSort(int page, int size, String keyword, String sort);

  Future<DataResponse<ProductPageResp>> searchProductPriceRangeSort(
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
  Future<DataResponse<ProductPageResp>> searchProductSort(int page, int size, String keyword, String sort) async {
    final url = baseUri(
      path: kAPISearchProductSortURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'search': keyword,
        'sort': sort,
      },
    );
    // send request
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
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
  Future<DataResponse<ProductPageResp>> searchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  ) async {
    final url = baseUri(
      path: kAPIGetSearchProductPriceRangeSortURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'search': keyword.toString(),
        'sort': sort.toString(),
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
      },
    );
    // send request
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
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
