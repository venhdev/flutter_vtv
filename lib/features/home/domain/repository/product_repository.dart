import '../../../../core/constants/typedef.dart';
import '../dto/favorite_product_resp.dart';
import '../dto/product_detail_resp.dart';
import '../dto/product_page_resp.dart';
import '../entities/category_entity.dart';
import '../entities/favorite_product_entity.dart';

abstract class ProductRepository {
  //# other
  FRespData<ProductDetailResp> getProductDetailById(int productId);

  //# product-suggestion-controller
  FRespData<ProductPageResp> getSuggestionProductsRandomly(int page, int size);

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
}
