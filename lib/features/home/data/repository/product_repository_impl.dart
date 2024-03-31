import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/home/data/data_sources/product_data_source.dart';
import 'package:flutter_vtv/features/home/domain/dto/favorite_product_resp.dart';
import 'package:flutter_vtv/features/home/domain/entities/category_entity.dart';
import 'package:flutter_vtv/features/home/domain/entities/favorite_product_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/product_resp.dart';
import '../../domain/repository/product_repository.dart';
import '../data_sources/category_data_source.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._productDataSource, this._categoryDataSource);

  final ProductDataSource _productDataSource;
  final CategoryDataSource _categoryDataSource;

  @override
  FRespData<ProductResp> getSuggestionProductsRandomly(int page, int size) async {
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
  FRespData<ProductResp> getProductFilter(int page, int size, String sortType) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.getProductFilter(page, size, sortType),
    );
  }

  @override
  FRespData<List<CategoryEntity>> getAllParentCategories() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _categoryDataSource.getAllParentCategories(),
    );
  }

  @override
  FRespData<FavoriteProductEntity> favoriteProductAdd(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.favoriteProductAdd(productId),
    );
  }

  @override
  Future<int?> isFavoriteProduct(int productId) async {
    try {
      final favoritesResp = await _productDataSource.favoriteProductList();
      log('favoritesResp: $favoritesResp');
      // check if the product is in the list of favorites
      // return favoritesResp.data.any((element) => element.productId == productId);

      // if there is a product in the list of favorites, return the favoriteProductId
      return favoritesResp.data
          .where(
            (element) => element.productId == productId,
          )
          .first
          .favoriteProductId;
    } catch (e) {
      return null;
    }
  }

  @override
  FRespEither favoriteProductDelete(int favoriteProductId) async {
    return await handleSuccessResponseFromDataSource(
      noDataCallback: () async => _productDataSource.favoriteProductDelete(favoriteProductId),
    );
  }

  @override
  FRespData<FavoriteProductEntity?> favoriteProductCheckExist(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.favoriteProductCheckExist(productId),
    );
  }

  @override
  FRespData<FavoriteProductResp> favoriteProductDetail(int favoriteProductId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.favoriteProductDetail(favoriteProductId),
    );
  }

  @override
  FRespData<List<FavoriteProductEntity>> favoriteProductList() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.favoriteProductList(),
    );
  }
}
