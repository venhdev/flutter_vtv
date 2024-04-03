import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/review_resp.dart';

abstract class ReviewDataSource {
  Future<DataResponse<ReviewResp>> getReviewProduct(int productId);
}

class ReviewDataSourceImpl implements ReviewDataSource {
  ReviewDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<DataResponse<ReviewResp>> getReviewProduct(int productId) async {
    final response = await _client.get(
      baseUri(
        path: '$kAPIReviewProductURL/$productId',
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ReviewResp>(
      response,
      '$kAPIReviewProductURL/$productId',
      (jsonMap) => ReviewResp.fromMap(jsonMap),
    );
  }
}
