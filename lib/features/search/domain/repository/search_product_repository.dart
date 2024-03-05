import '../../../../core/constants/typedef.dart';
import '../response/page_product_response.dart';

abstract class SearchProductRepository {

  RespEitherData<PageProductResponse> searchAndPriceRangePageProductBySort(
      int page,
      int size,
      String keyword,
      String sort,
      int minPrice,
      int maxPrice);

  RespEitherData<PageProductResponse> searchPageProductBySort(
      int page, int size, String keyword, String sort);


}
