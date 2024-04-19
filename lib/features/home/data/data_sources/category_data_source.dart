import 'package:flutter_vtv/features/home/data/models/category_model.dart';
import 'package:http/http.dart' as http show Client;
import 'package:vtv_common/vtv_common.dart';

abstract class CategoryDataSource {
  Future<SuccessResponse<List<CategoryModel>>> getAllParentCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final http.Client _client;

  CategoryDataSourceImpl(this._client);

  @override
  Future<SuccessResponse<List<CategoryModel>>> getAllParentCategories() async {
    // send request
    final url = baseUri(path: kAPIAllCategoryURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<List<CategoryModel>>(
      response,
      url,
      (jsonMap) => CategoryModel.fromMapToList(jsonMap),
    );

    // // decode response using utf8
    // final utf8BodyMap = utf8.decode(response.bodyBytes);
    // final decodedBody = jsonDecode(utf8BodyMap);

    // // handle response
    // if (response.statusCode == 200) {
    //   final result = CategoryModel.fromJsonList(utf8BodyMap);
    //   return SuccessResponse<List<CategoryModel>>(
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
}
