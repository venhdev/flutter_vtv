import '../../../../core/constants/typedef.dart';
import '../response/product_resp.dart';

abstract class SearchProductRepository {
  /// Search keyword + sort + price range
  FRespData<ProductResp> getSearchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  );

  /// Search keyword + sort (no price range)
  FRespData<ProductResp> searchProductSort(
    int page,
    int size,
    String keyword,
    String sort,
  );
}
