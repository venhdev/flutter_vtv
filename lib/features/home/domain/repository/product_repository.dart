import '../../../../core/constants/typedef.dart';
import '../dto/favorite_product_resp.dart';
import '../dto/product_resp.dart';
import '../entities/category_entity.dart';
import '../entities/favorite_product_entity.dart';

abstract class ProductRepository {
  FRespData<ProductResp> getSuggestionProductsRandomly(int page, int size);

  FRespData<ProductResp> getProductFilter(int page, int size, String sortType);

  FRespData<ProductResp> getProductFilterByPriceRange(
    int page,
    int size,
    int minPrice,
    int maxPrice,
    String filter,
  );

  // Category
  FRespData<List<CategoryEntity>> getAllParentCategories();

  //! Favorite Product
  FRespData<FavoriteProductEntity> favoriteProductAdd(int productId);
  FRespEither favoriteProductDelete(int favoriteProductId);
  Future<int?> isFavoriteProduct(int productId);
  FRespData<FavoriteProductEntity?> favoriteProductCheckExist(int productId);

  FRespData<List<FavoriteProductEntity>> favoriteProductList();
  FRespData<FavoriteProductResp> favoriteProductDetail(int favoriteProductId);
}
