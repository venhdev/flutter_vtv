import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../order/domain/dto/review_param.dart';
import '../../domain/repository/product_repository.dart';
import '../data_sources/category_data_source.dart';
import '../data_sources/local_product_data_source.dart';
import '../data_sources/product_data_source.dart';
import '../data_sources/review_data_source.dart';

class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(
    this._productDataSource,
    this._categoryDataSource,
    this._localProductDataSource,
    this._reviewDataSource,
  );

  final ProductDataSource _productDataSource;
  final CategoryDataSource _categoryDataSource;
  final LocalProductDataSource _localProductDataSource;
  final ReviewDataSource _reviewDataSource;

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
          return product.data!;
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

  @override
  FRespData<ProductPageResp> getSuggestionProductsRandomlyByAlikeProduct(
    int page,
    int size,
    int productId,
    bool inShop,
  ) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.getSuggestionProductsRandomlyByAlikeProduct(
        page,
        size,
        productId,
        inShop,
      ),
    );
  }

  @override
  FRespData<ReviewResp> getReviewProduct(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _reviewDataSource.getReviewProduct(productId),
    );
  }

  @override
  FRespData<ReviewEntity> addReview(ReviewParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _reviewDataSource.addReview(params));
  }

  @override
  FRespData<bool> checkExistReview(String orderItemId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _reviewDataSource.checkExistReview(orderItemId));
  }

  @override
  FRespEither deleteReview(String reviewId) async {
    return handleSuccessResponseFromDataSource(noDataCallback: () => _reviewDataSource.deleteReview(reviewId));
  }

  @override
  FRespData<ReviewEntity> getReviewDetail(String orderItemId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _reviewDataSource.getReviewDetail(orderItemId));
  }

  Future<bool> isReviewedItem(OrderItemEntity orderItem) async {
    final rs = await _reviewDataSource.checkExistReview(orderItem.orderItemId!);
    return rs.data!;
  }

  @override
  FResult<bool> isOrderReviewed(OrderEntity order) async {
    //> check if any item in the order is not reviewed
    try {
      final multiCheck = await Future.wait(order.orderItems.map((item) async => isReviewedItem(item)));

      log('{isOrderReviewed} multiCheck: $multiCheck');

      final rs = multiCheck.every((check) => check == true); // true means the item is reviewed
      log('{isOrderReviewed} isOrderReviewed: $rs');

      return Right(rs);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<void> addReviews(List<ReviewParam> params) async {
    try {
      await Future.wait(params.map((param) async {
        await _reviewDataSource.addReview(param);
      }));
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<List<ReviewEntity>> getAllReviewDetailByOrder(OrderEntity order) async {
    try {
      final rs = await Future.wait(order.orderItems.map((item) async {
        final review = await _reviewDataSource.getReviewDetail(item.orderItemId!);
        return review.data!;
      }));
      return Right(rs);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FRespData<int> getProductCountFavorite(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _productDataSource.getProductCountFavorite(productId),
    );
  }

  @override
  FRespData<ProductPageResp> getProductPageByShop(int page, int size, int shopId) {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.getProductPageByShop(page, size, shopId),
    );
  }

  @override
  FRespData<int> countShopFollowed(int shopId) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.countShopFollowed(shopId),
    );
  }

  @override
  FRespData<FollowedShopEntity> followedShopAdd(int shopId) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.followedShopAdd(shopId),
    );
  }

  @override
  FRespEither followedShopDelete(int followedShopId) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.followedShopDelete(followedShopId),
    );
  }

  @override
  FRespData<List<FollowedShopEntity>> followedShopList() async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _productDataSource.followedShopList(),
    );
  }

  @override
  FResult<int?> followedShopCheckExist(int shopId) async {
    try {
      final listResp = await _productDataSource.followedShopList();
      // final FollowedShopEntity rs = list.data!.firstWhere((e) => e.shopId == shopId);
      for (var e in listResp.data!) {
        if (e.shopId == shopId) {
          return Right(e.followedShopId);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
