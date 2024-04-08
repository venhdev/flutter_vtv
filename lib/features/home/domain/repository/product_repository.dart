import 'package:vtv_common/vtv_common.dart';

abstract class ProductRepository {
  //# other
  FRespData<ProductDetailResp> getProductDetailById(int productId);

  //# product-suggestion-controller
  FRespData<ProductPageResp> getSuggestionProductsRandomly(int page, int size);
  FRespData<ProductPageResp> getSuggestionProductsRandomlyByAlikeProduct(
    int page,
    int size,
    int productId,
    bool inShop,
  );

  //# product-filter-controller
  FRespData<ProductPageResp> getProductFilter(int page, int size, String sortType);
  FRespData<ProductPageResp> getProductFilterByPriceRange(
    int page,
    int size,
    int minPrice,
    int maxPrice,
    String filter,
  );

  //# Category
  FRespData<List<CategoryEntity>> getAllParentCategories();

  //# favorite-product-controller
  FRespData<List<FavoriteProductEntity>> favoriteProductList();
  FRespData<FavoriteProductResp> favoriteProductDetail(int favoriteProductId);
  FRespData<FavoriteProductEntity?> favoriteProductCheckExist(int productId);
  FRespData<FavoriteProductEntity> favoriteProductAdd(int productId);
  FRespEither favoriteProductDelete(int favoriteProductId);

  //# Local
  FResult<void> cacheRecentViewedProductId(int productId);
  FResult<List<ProductDetailResp>> getRecentViewedProducts();

  //# product-page-controller
  FRespData<ProductPageResp> getProductPageByCategory(int page, int size, int categoryId);

  //# review-controller
  FRespData<ReviewResp> getReviewProduct(int productId);
}
