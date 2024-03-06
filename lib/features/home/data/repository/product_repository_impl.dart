import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/home/data/data_sources/product_data_source.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/dto/product_dto.dart';
import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._productDataSource);

  final ProductDataSource _productDataSource;

  @override
  FRespData<ProductDTO> getSuggestionProductsRandomly(int page, int size) async {
    try {
      final result = await _productDataSource.getSuggestionProductsRandomly(page, size);
      return Right(result);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }
}
