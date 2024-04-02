import 'package:dartz/dartz.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/favorite_product_resp.dart';
import '../../domain/dto/product_detail_resp.dart';
import '../../domain/dto/product_page_resp.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/favorite_product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../data_sources/category_data_source.dart';
import '../data_sources/local_product_data_source.dart';
import '../data_sources/product_data_source.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(
    this._productDataSource,
    this._categoryDataSource,
    this._localProductDataSource,
  );

  final ProductDataSource _productDataSource;
  final CategoryDataSource _categoryDataSource;
  final LocalProductDataSource _localProductDataSource;

  @override
  FRespData<ProductPageResp> getSuggestionProductsRandomly(int page, int size) async {
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
  FRespData<ProductPageResp> getProductFilterByPriceRange(
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
  FRespData<ProductPageResp> getProductFilter(int page, int size, String sortType) async {
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

  @override
  FResult<List<ProductDetailResp>> getRecentViewedProducts() async {
    try {
      final recentProductIds = await _localProductDataSource.getRecentProductIds();
      if (recentProductIds.isEmpty) {
        return const Right([]);
      }

      final products = await Future.wait(
        recentProductIds.map((productId) async {
          final product = await _productDataSource.getProductDetailById(int.parse(productId));
          return product.data;
        }),
      );

      return Right(products);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<void> cacheRecentViewedProductId(int productId) async {
    try {
      await _localProductDataSource.cacheProductId(productId);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FRespData<ProductDetailResp> getProductDetailById(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.getProductDetailById(productId),
    );
  }

  @override
  FRespData<ProductPageResp> getProductPageByCategory(int page, int size, int categoryId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.getProductPageByCategory(page, size, categoryId),
    );
  }
}
