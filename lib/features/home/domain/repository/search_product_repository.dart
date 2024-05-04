import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../entities/search_history_resp.dart';

abstract class SearchProductRepository {
  /// Search keyword + sort + price range
  FRespData<ProductPageResp> getSearchProductPriceRangeSort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice);

  /// Search keyword + sort (no price range)
  FRespData<ProductPageResp> searchProductSort(int page, int size, String keyword, String sort);

  /// Search keyword + sort + shopId + price range
  FRespData<ProductPageResp> searchProductShopPriceRangeSort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice, int shopId);

  /// Search keyword + sort + shopId (no price range)
  FRespData<ProductPageResp> searchProductShopSort(int page, int size, String keyword, String sort, int shopId);

  //# search-history-controller
  FRespEither searchHistoryAdd(String query);
  FRespData<SearchHistoryResp> searchHistoryGetPage(int page, int size);
  FRespEither searchHistoryDelete(String searchHistoryId);
}
