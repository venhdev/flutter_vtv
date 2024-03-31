import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/favorite_product_resp.dart';
import '../../domain/dto/product_resp.dart';
import '../../domain/entities/favorite_product_entity.dart';

abstract class ProductDataSource {
  Future<DataResponse<ProductResp>> getSuggestionProductsRandomly(int page, int size);

  Future<DataResponse<ProductResp>> getProductFilter(int page, int size, String sortType);

  Future<DataResponse<ProductResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  });

  //! Favorite Product
  Future<DataResponse<List<FavoriteProductEntity>>> favoriteProductList();
  Future<DataResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity>> favoriteProductAdd(int productId);
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId);
}

class ProductDataSourceImpl implements ProductDataSource {
  ProductDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<ProductResp>> getSuggestionProductsRandomly(int page, int size) async {
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
      '$kAPIProductFilterPriceRangeURL/$filter',
      (jsonMap) => ProductResp.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<ProductResp>> getProductFilter(int page, int size, String sortType) async {
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
      '$kAPIProductFilterURL/$sortType',
      (jsonMap) => ProductResp.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<FavoriteProductEntity>> favoriteProductAdd(int productId) async {
    final response = await _client.post(
      baseUri(path: '$kAPIFavoriteProductAddURL/$productId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductEntity>(
      response,
      '$kAPIFavoriteProductAddURL/$productId',
      (jsonMap) => FavoriteProductEntity.fromMap(jsonMap['favoriteProductDTO']),
    );

  }

  @override
  Future<DataResponse<List<FavoriteProductEntity>>> favoriteProductList() async {
    final response = await _client.get(
      baseUri(path: kAPIFavoriteProductListURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<FavoriteProductEntity>>(
      response,
      kAPIFavoriteProductListURL,
      (jsonMap) => FavoriteProductEntity.fromList(jsonMap['favoriteProductDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId) async {
    final response = await _client.delete(
      baseUri(path: '$kAPIFavoriteProductDeleteURL/$favoriteProductId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(response, '$kAPIFavoriteProductDeleteURL/$favoriteProductId');
  }

  @override
  Future<DataResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId) async {
    final response = await _client.get(
      baseUri(path: '$kAPIFavoriteProductCheckExistURL/$productId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductEntity?>(
      response,
      '$kAPIFavoriteProductCheckExistURL/$productId',
      (jsonMap) => FavoriteProductEntity.fromMapNull(jsonMap['favoriteProductDTO']),
    );
  }

  @override
  Future<DataResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId) async {
    final response = await _client.get(
      baseUri(path: '$kAPIFavoriteProductDetailURL/$favoriteProductId'),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductResp>(
      response,
       '$kAPIFavoriteProductDetailURL/$favoriteProductId',
      (jsonMap) => FavoriteProductResp.fromMap(jsonMap),
    );
  }
}
