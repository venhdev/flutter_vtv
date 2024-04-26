import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/shop.dart';

import '../../../order/domain/dto/review_param.dart';
import '../dto/comment_param.dart';

abstract class ProductRepository {
  //# local storage
  FResult<void> cacheRecentViewedProductId(int productId);
  FResult<List<ProductDetailResp>> getRecentViewedProducts();

  //# product-controller
  FRespData<ProductDetailResp> getProductDetailById(int productId);
  FRespData<int> getProductCountFavorite(int productId);

  //# product-suggestion-controller
  FRespData<ProductPageResp> getSuggestionProductsRandomly(int page, int size);
  FRespData<ProductPageResp> getSuggestionProductsRandomlyByAlikeProduct(
    int page,
    int size,
    int productId,
    bool inShop,
  );

  //# product-filter-controller
  FRespData<ProductPageResp> getProductFilter(int page, int size, String sortType);
  FRespData<ProductPageResp> getProductFilterByPriceRange(
    int page,
    int size,
    int minPrice,
    int maxPrice,
    String filter,
  );

  //# Category
  FRespData<List<CategoryEntity>> getAllParentCategories();

  //# favorite-product-controller
  FRespData<List<FavoriteProductEntity>> favoriteProductList();
  FRespData<FavoriteProductResp> favoriteProductDetail(int favoriteProductId);
  FRespData<FavoriteProductEntity?> favoriteProductCheckExist(int productId);
  FRespData<FavoriteProductEntity> favoriteProductAdd(int productId);
  FRespEither favoriteProductDelete(int favoriteProductId);

  //# product-page-controller
  FRespData<ProductPageResp> getProductPageByCategory(int page, int size, int categoryId);
  FRespData<ProductPageResp> getProductPageByShop(int page, int size, int shopId);

  //*---------------------START REVIEW-----------------------*//
  //# review-controller
  FRespData<ReviewResp> getProductReviews(int productId);
  FRespData<ReviewEntity> getReviewDetailByReviewId(String reviewId);

  //# review-customer-controller
  FRespData<ReviewEntity> addReview(ReviewParam params);
  FResult<void> addReviews(List<ReviewParam> params); // custom: add multiple reviews
  FRespData<bool> checkExistReview(String orderItemId);

  /// check if all items in the order have been reviewed
  /// - return true if all items are reviewed
  /// - return false if there is at least one item not reviewed
  FResult<bool> isOrderReviewed(OrderEntity order); // custom: check review status of an order
  FRespEither deleteReview(String reviewId);
  FRespData<ReviewEntity> getReviewDetail(String orderItemId);
  FResult<List<ReviewEntity>> getAllReviewDetailByOrder(OrderEntity order); // custom: get reviews of an order

  //# comment-customer-controller
  FRespData<CommentEntity> addCustomerComment(CommentParam param);
  FRespEither deleteCustomerComment(String commentId); //uuid

  //# comment-controller
  FRespData<List<CommentEntity>> getReviewComments(String reviewId); //uuid

  //*---------------------END REVIEW-----------------------*//

  //*---------------------START SHOP-----------------------*//

  //# shop-detail-controller
  FRespData<int> countShopFollowed(int shopId);
  FRespData<ShopDetailResp> getShopDetailById(int shopId);

  //# followed-shop-controller
  FRespData<FollowedShopEntity> followedShopAdd(int shopId);
  FRespData<List<FollowedShopEntity>> followedShopList();
  FRespEither followedShopDelete(int followedShopId);

  /// return followedShopId if exist, null if not found
  FResult<int?> followedShopCheckExist(int shopId); // custom: get list then check contain
  //*---------------------END SHOP-----------------------*//
}
