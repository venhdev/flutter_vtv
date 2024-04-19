import 'package:vtv_common/vtv_common.dart';

abstract class SearchProductRepository {
  /// Search keyword + sort + price range
  FRespData<ProductPageResp> getSearchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  );

  /// Search keyword + sort (no price range)
  FRespData<ProductPageResp> searchProductSort(
    int page,
    int size,
    String keyword,
    String sort,
  );
}
