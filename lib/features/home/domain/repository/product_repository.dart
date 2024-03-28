import '../../../../core/constants/typedef.dart';
import '../dto/product_resp.dart';
import '../entities/category_entity.dart';

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
}
