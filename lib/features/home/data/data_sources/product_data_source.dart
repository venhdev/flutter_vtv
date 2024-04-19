import 'package:http/http.dart' as http show Client;
import 'package:dio/dio.dart' as dio;
import 'package:vtv_common/vtv_common.dart';

//! Remote data source
abstract class ProductDataSource {
  //# product-suggestion-controller
  Future<SuccessResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size);
  Future<SuccessResponse<ProductPageResp>> getSuggestionProductsRandomlyByAlikeProduct(
      int page, int size, int productId, bool inShop);

  //# product-filter-controller
  Future<SuccessResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType);
  Future<SuccessResponse<ProductPageResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  });

  //# favorite-product-controller
  Future<SuccessResponse<List<FavoriteProductEntity>>> favoriteProductList();
  Future<SuccessResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId);
  Future<SuccessResponse<FavoriteProductEntity>> favoriteProductAdd(int productId);
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId);
  Future<SuccessResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId);

  //# product-controller
  Future<SuccessResponse<ProductDetailResp>> getProductDetailById(int productId);
  Future<SuccessResponse<int>> getProductCountFavorite(int productId);

  //# product-page-controller
  Future<SuccessResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId);
  Future<SuccessResponse<ProductPageResp>> getProductPageByShop(int page, int size, int shopId);

  //# shop-detail-controller
  Future<SuccessResponse<int>> countShopFollowed(int shopId);

  //# followed-shop-controller
  Future<SuccessResponse<FollowedShopEntity>> followedShopAdd(int shopId);
  Future<SuccessResponse<List<FollowedShopEntity>>> followedShopList();
  Future<SuccessResponse> followedShopDelete(int followedShopId);
}

class ProductDataSourceImpl implements ProductDataSource {
  ProductDataSourceImpl(this._client, this._secureStorageHelper, this._dio);

  final http.Client _client;
  final dio.Dio _dio;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<SuccessResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size) async {
    final url = baseUri(
      path: kAPISuggestionProductPageRandomlyURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      },
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductPageResp>(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  }) async {
    final url = baseUri(
      path: '$kAPIProductFilterPriceRangeURL/$filter',
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
      },
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductPageResp>(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType) async {
    final url = baseUri(
      path: '$kAPIProductFilterURL/$sortType',
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      },
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductPageResp>(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<FavoriteProductEntity>> favoriteProductAdd(int productId) async {
    final url = baseUri(path: '$kAPIFavoriteProductAddURL/$productId');
    final response = await _client.post(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductEntity>(
      response,
      url,
      (jsonMap) => FavoriteProductEntity.fromMap(jsonMap['favoriteProductDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<FavoriteProductEntity>>> favoriteProductList() async {
    final url = baseUri(path: kAPIFavoriteProductListURL);
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<List<FavoriteProductEntity>>(
      response,
      url,
      (jsonMap) => FavoriteProductEntity.fromList(jsonMap['favoriteProductDTOs'] as List<dynamic>),
    );
  }

  @override
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId) async {
    final url = baseUri(path: '$kAPIFavoriteProductDeleteURL/$favoriteProductId');
    final response = await _client.delete(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseNoData(
      response,
      url,
    );
  }

  @override
  Future<SuccessResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId) async {
    final url = baseUri(path: '$kAPIFavoriteProductCheckExistURL/$productId');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductEntity?>(
      response,
      url,
      (jsonMap) => FavoriteProductEntity.fromMapNull(jsonMap['favoriteProductDTO']),
    );
  }

  @override
  Future<SuccessResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId) async {
    final url = baseUri(path: '$kAPIFavoriteProductDetailURL/$favoriteProductId');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    return handleResponseWithData<FavoriteProductResp>(
      response,
      url,
      (jsonMap) => FavoriteProductResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductDetailResp>> getProductDetailById(int productId) async {
    final url = baseUri(path: '$kAPIProductDetailURL/$productId');
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductDetailResp>(
      response,
      url,
      (jsonMap) => ProductDetailResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId) async {
    final url = baseUri(
      path: '$kAPIProductPageCategoryURL/$categoryId',
      queryParameters: {
        'page': page,
        'size': size,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductPageResp>(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getSuggestionProductsRandomlyByAlikeProduct(
      int page, int size, int productId, bool inShop) async {
    final url = baseUri(
      path: '$kAPISuggestionProductPageRandomlyByAlikeProductURL/$productId',
      queryParameters: {
        'page': page,
        'size': size,
        'inShop': inShop,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    final response = await _client.get(
      url,
      headers: baseHttpHeaders(),
    );

    return handleResponseWithData<ProductPageResp>(
      response,
      url,
      (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<int>> getProductCountFavorite(int productId) async {
    final url = baseUri(path: '$kAPIProductCountFavoriteURL/$productId');

    final response = await _dio.getUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(),
      ),
    );

    return handleDioResponse<int, int>(
      response,
      url,
      parse: (count) => count,
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getProductPageByShop(int page, int size, int shopId) async {
    final url = baseUri(
      path: '$kAPIProductPageShopURL/$shopId',
      queryParameters: {
        'page': page,
        'size': size,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await _dio.getUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(),
      ),
    );

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<int>> countShopFollowed(int shopId) async {
    final url = baseUri(path: '$kAPIShopDetailCountFollowedURL/$shopId');
    final response = await _dio.getUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(
          accessToken: await _secureStorageHelper.accessToken, // REVIEW why need accessToken here?
        ),
      ),
    );

    return handleDioResponse<int, int>(
      response,
      url,
      parse: (count) => count,
    );
  }

  @override
  Future<SuccessResponse<FollowedShopEntity>> followedShopAdd(int shopId) async {
    final url = baseUri(
      path: kAPIFollowedShopAddURL,
      queryParameters: {'shopId': shopId.toString()},
    );

    final response = await _dio.postUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      ),
    );

    return handleDioResponse<FollowedShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => FollowedShopEntity.fromMap(jsonMap['followedShopDTO']),
    );
  }

  @override
  Future<SuccessResponse> followedShopDelete(int followedShopId) async {
    final url = baseUri(path: '$kAPIFollowedShopDeleteURL/$followedShopId');

    final response = await _dio.deleteUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      ),
    );

    return handleDioResponse<Object?, Map<String, dynamic>>(
      response,
      url,
      hasData: false,
    );
  }

  @override
  Future<SuccessResponse<List<FollowedShopEntity>>> followedShopList() async {
    final url = baseUri(path: kAPIFollowedShopListURL);

    final response = await _dio.getUri(
      url,
      options: dio.Options(
        headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      ),
    );

    return handleDioResponse<List<FollowedShopEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonList) => (jsonList['followedShopDTOs'] as List)
          .map(
            (jsonMap) => FollowedShopEntity.fromMap(jsonMap),
          )
          .toList(),
    );
  }
}
