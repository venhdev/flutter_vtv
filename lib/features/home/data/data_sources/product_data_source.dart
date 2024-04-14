import 'package:http/http.dart' as http show Client;
import 'package:vtv_common/vtv_common.dart';

//! Remote data source
abstract class ProductDataSource {
  //# product-suggestion-controller
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size);
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomlyByAlikeProduct(
      int page, int size, int productId, bool inShop);

  //# product-filter-controller
  Future<DataResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType);
  Future<DataResponse<ProductPageResp>> getProductFilterByPriceRange({
    required int page,
    required int size,
    required int minPrice,
    required int maxPrice,
    required String filter,
  });

  //# favorite-product-controller
  Future<DataResponse<List<FavoriteProductEntity>>> favoriteProductList();
  Future<DataResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity>> favoriteProductAdd(int productId);
  Future<SuccessResponse> favoriteProductDelete(int favoriteProductId);
  Future<DataResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId);

  //# product-controller
  Future<DataResponse<ProductDetailResp>> getProductDetailById(int productId);

  //# product-page-controller
  Future<DataResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId);
}

class ProductDataSourceImpl implements ProductDataSource {
  ProductDataSourceImpl(this._client, this._secureStorageHelper);

  final http.Client _client;
  final SecureStorageHelper _secureStorageHelper;

  @override
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomly(int page, int size) async {
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
  Future<DataResponse<ProductPageResp>> getProductFilterByPriceRange({
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
  Future<DataResponse<ProductPageResp>> getProductFilter(int page, int size, String sortType) async {
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
  Future<DataResponse<FavoriteProductEntity>> favoriteProductAdd(int productId) async {
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
  Future<DataResponse<List<FavoriteProductEntity>>> favoriteProductList() async {
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
  Future<DataResponse<FavoriteProductEntity?>> favoriteProductCheckExist(int productId) async {
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
  Future<DataResponse<FavoriteProductResp>> favoriteProductDetail(int favoriteProductId) async {
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
  Future<DataResponse<ProductDetailResp>> getProductDetailById(int productId) async {
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
  Future<DataResponse<ProductPageResp>> getProductPageByCategory(int page, int size, int categoryId) async {
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
  Future<DataResponse<ProductPageResp>> getSuggestionProductsRandomlyByAlikeProduct(
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
}
