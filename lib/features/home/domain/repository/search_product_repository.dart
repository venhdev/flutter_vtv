import '../../../../core/constants/typedef.dart';
import '../dto/product_dto.dart';

abstract class SearchProductRepository {

  FRespData<ProductDTO> searchAndPriceRangePageProductBySort(
      int page,
      int size,
      String keyword,
      String sort,
      int minPrice,
      int maxPrice);

  FRespData<ProductDTO> searchPageProductBySort(
      int page, int size, String keyword, String sort);


}
