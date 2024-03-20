import 'package:flutter_vtv/core/constants/typedef.dart';

import '../../../../core/network/response_handler.dart';
import '../../domain/dto/product_resp.dart';
import '../../domain/repository/search_product_repository.dart';
import '../data_sources/search_product_data_source.dart';

class SearchProductRepositoryImpl extends SearchProductRepository {
  SearchProductRepositoryImpl(this._searchProductDataSource);

  final SearchProductDataSource _searchProductDataSource;

  @override
  FRespData<ProductResp> getSearchProductPriceRangeSort(
    int page,
    int size,
    String keyword,
    String sort,
    int minPrice,
    int maxPrice,
  ) async {
    return handleDataResponseFromDataSource(
      dataCallback: () async =>
          _searchProductDataSource.searchProductPriceRangeSort(
        page,
        size,
        keyword,
        sort,
        minPrice,
        maxPrice,
      ),
    );
    // try {
    //   final result = _searchProductDataSource.searchProductPriceRangeSort(page, size, keyword, sort, minPrice, maxPrice);
    //   return FRespData(Right(Future.value(result)) as FutureOr<Either<ErrorResponse, DataResponse<ProductDTO>>> Function());
    // } on ClientException catch (e) {
    //   return FRespData(Left(ClientError(code: e.code, message: e.message))
    //       as FutureOr<Either<ErrorResponse, DataResponse<ProductDTO>>> Function());
    // } on ServerException catch (e) {
    //   return FRespData(Left(ServerError(code: e.code, message: e.message))
    //       as FutureOr<Either<ErrorResponse, DataResponse<ProductDTO>>> Function());
    // } catch (e) {
    //   return FRespData(
    //       Left(UnexpectedError(message: e.toString())) as FutureOr<Either<ErrorResponse, DataResponse<ProductDTO>>> Function());
    // }
  }

  @override
  FRespData<ProductResp> searchProductSort(
      int page, int size, String keyword, String sort) async {
    return handleDataResponseFromDataSource(
      dataCallback: () =>
          _searchProductDataSource.searchProductSort(page, size, keyword, sort),
    );
    // try {
    //   final result = await _searchProductDataSource.searchProductSort(page, size, keyword, sort);
    //   return Right(result);
    // } on ClientException catch (e) {
    //   return Left(ClientError(code: e.code, message: e.message));
    // } on ServerException catch (e) {
    //   return Left(ServerError(code: e.code, message: e.message));
    // } catch (e) {
    //   return Left(UnexpectedError(message: e.toString()));
    // }
  }
}
