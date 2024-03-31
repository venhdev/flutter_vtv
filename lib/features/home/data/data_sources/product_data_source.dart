import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/favorite_product_resp.dart';
import '../../domain/dto/product_detail_resp.dart';
import '../../domain/dto/product_page_resp.dart';
import '../../domain/entities/favorite_product_entity.dart';

//! Remote data source
abstract class ProductDataSource {
  //* product-suggestion-controller
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size);

  //* product-filter-controller
  Future<DataResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType);
  Future<DataResponse<ProductPageResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  });

  //* favorite-product-controller
  Future<DataResponse<List<FavoriteProductEntity>>> favoriteProductList();
  Future<DataResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity>> favoriteProductAdd(int productId);
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId);

  //*product-controller
  Future<DataResponse<ProductDetailResp>> getProductDetailById(String productId);
}

class ProductDataSourceImpl implements ProductDataSource {
  ProductDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size) async {
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

    return handleResponseWithData<ProductPageResp>(
      response,
      kAPISuggestionProductURL,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<ProductPageResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  }) async {
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

    return handleResponseWithData<ProductPageResp>(
      response,
      '$kAPIProductFilterPriceRangeURL/$filter',
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<DataResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType) async {
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

    return handleResponseWithData<ProductPageResp>(
      response,
      '$kAPIProductFilterURL/$sortType',
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
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
  
  @override
  Future<DataResponse<ProductDetailResp>> getProductDetailById(String productId) async{
    final response = await _client.get(
      baseUri(path: '$kAPIProductDetailURL/$productId'),
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductDetailResp>(
      response,
      '$kAPIProductDetailURL/$productId',
      (jsonMap) => ProductDetailResp.fromMap(jsonMap),
    );
  }
}
