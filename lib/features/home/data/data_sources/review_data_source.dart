import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

abstract class ReviewDataSource {
  Future<DataResponse<ReviewResp>> getReviewProduct(int productId);
}

class ReviewDataSourceImpl implements ReviewDataSource {
  ReviewDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<DataResponse<ReviewResp>> getReviewProduct(int productId) async {
    final url = baseUri(
      path: '$kAPIReviewProductURL/$productId',
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ReviewResp>(
      response,
      url,
      (jsonMap) => ReviewResp.fromMap(jsonMap),
    );
  }
}

// class TestDio {
//   final options = BaseOptions(
//     baseUrl: 'https://jsonplaceholder.typicode.com',
//     connectTimeout: const Duration(seconds: 5),
//     receiveTimeout: 3000,
//   );
//   final Dio _dio = Dio();
// }
