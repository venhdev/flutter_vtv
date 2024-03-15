import '../../../../core/constants/typedef.dart';
import '../dto/product_dto.dart';

abstract class SearchProductRepository {
  /// Search keyword + sort + price range
  FRespData<ProductDTO> getSearchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  );

  /// Search keyword + sort (no price range)
  FRespData<ProductDTO> searchProductSort(
    int page,
    int size,
    String keyword,
    String sort,
  );
}
