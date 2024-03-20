import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/home/data/data_sources/product_data_source.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/product_resp.dart';
import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._productDataSource);

  final ProductDataSource _productDataSource;

  @override
  FRespData<ProductResp> getSuggestionProductsRandomly(
      int page, int size) async {
    try {
      final result =
          await _productDataSource.getSuggestionProductsRandomly(page, size);
      return Right(result);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespData<ProductResp> getProductFilterByPriceRange(
    int page,
    int size,
    int minPrice,
    int maxPrice,
    String filter,
  ) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.getProductFilterByPriceRange(
        page: page,
        size: size,
        minPrice: minPrice,
        maxPrice: maxPrice,
        filter: filter,
      ),
    );
  }

  @override
  FRespData<ProductResp> getProductFilter(
      int page, int size, String sortType) async {
    return handleDataResponseFromDataSource(
      dataCallback: () =>
          _productDataSource.getProductFilter(page, size, sortType),
    );
  }
}
