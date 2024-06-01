import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/shop.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/components/cart_badge.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product/product_item.dart';
import '../components/product/sheet_add_to_cart_or_buy_now.dart';
import '../components/review/review_item.dart';
import 'product_reviews_page.dart';
import 'shop_page.dart';

//! ProductDetailPage is the page showing all information of a product
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    this.productId,
    this.productDetail,
  })  : assert(productId != null || productDetail != null, 'productId or productDetail must not be null'),
        assert(productId == null || productDetail == null, 'cannot pass both productId and productDetail');

  final int? productId;
  final ProductDetailResp? productDetail;

  static const String routeName = 'product';
  static const String path = '/home/product';

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late LazyLoadController<ProductEntity> _lazyController;
  bool _isShowMoreDescription = false;
  bool _isShowMoreInformation = false;

  bool _isInitializing = true;
  late ProductDetailResp _productDetail;

  // others state
  // int? _favoriteProductId;
  int? _followedShopId;

  void fetchProductDetail(int id) async {
    final respEither = await sl<ProductRepository>().getProductDetailById(id);

    respEither.fold(
      (error) => log('Error: ${error.message}'),
      (ok) {
        setState(() {
          _productDetail = ok.data!;
          _isInitializing = false;
        });

        checkFollowedShop(ok.data!.shopId);
      },
    );
  }

  void handleTapFavoriteButton(int? favoriteProductId) async {
    // add to favorite
    if (favoriteProductId == null) {
      final respEither = await sl<ProductRepository>().favoriteProductAdd(_productDetail.product.productId);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã thêm vào yêu thích');
          setState(() {});
        },
      );
      // return;
    } else {
      final respEither = await sl<ProductRepository>().favoriteProductDelete(favoriteProductId);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã xóa khỏi yêu thích');
          setState(() {
            favoriteProductId = null;
          });
        },
      );
    }
  }

  void cacheRecentView() async {
    final respEither = await sl<ProductRepository>().cacheRecentViewedProductId(
      // _productDetail.product.productId.toString(),
      widget.productId ?? widget.productDetail!.product.productId,
    );

    respEither.fold(
      (error) => log('Error: ${error.message}'),
      (ok) => log(
        'Cache success with productId: ${widget.productId ?? widget.productDetail!.product.productId}',
      ),
    );
  }

  void checkFollowedShop(int shopId) async {
    if (context.read<AuthCubit>().state.status != AuthStatus.authenticated) return;

    final respEither = await sl<ProductRepository>().followedShopCheckExist(shopId);
    respEither.fold(
      (error) => log('Error: ${error.message}'),
      (ok) {
        if (mounted) {
          setState(() {
            _followedShopId = ok;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _lazyController.scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _lazyController = LazyLoadController(
      scrollController: ScrollController(),
      items: [],
      useGrid: true,
      emptyMessage: 'Không tìm thấy sản phẩm tương tự',
    );
    if (widget.productId != null) {
      fetchProductDetail(widget.productId!);
    } else {
      _productDetail = widget.productDetail!;
      checkFollowedShop(_productDetail.shopId);
      _isInitializing = false;
    }
    // checkIsFavorite();
    cacheRecentView();
  }

  @override
  Widget build(BuildContext context) {
    log('(ProductDetailPage) build with productId: ${widget.productId}');
    return Scaffold(
      // bottomSheet: _showBottomSheet ? _buildBottomActionBar(context) : null,
      bottomSheet: _buildBottomActionBar(context),
      body: _isInitializing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                fetchProductDetail(_productDetail.product.productId);
              },
              child: _buildBody(context),
            ),
    );
  }

  CustomScrollView _buildBody(BuildContext context) {
    return CustomScrollView(
      controller: _lazyController.scrollController,
      slivers: <Widget>[
        //# image
        _buildSliverAppBar(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              //# price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    _buildProductPrice(),
                    const SizedBox(height: 8),

                    //# name
                    _buildProductName(),
                    _buildMoreInfo(), // rating, sold, favorite
                    const SizedBox(height: 8),

                    //# shop info
                    _buildShopInfo(),
                    const SizedBox(height: 8),

                    //# description
                    _buildProductDescription(),

                    //# review
                    _buildProductReview(),

                    //# suggestion products (if any alike current product)
                    _buildSuggestionProducts(),
                  ],
                ),
              ),

              const SizedBox(height: 56),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShopInfo() {
    return FutureBuilder(
      future: sl<GuestRepository>().getShopDetailById(_productDetail.shopId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => ShopInfo(
              shopId: _productDetail.shopId,
              shopDetail: ok.data!,
              showViewShopBtn: true,
              onViewPressed: () => context.push('${ShopPage.path}/${_productDetail.shopId}'),
              showFollowBtn: true,
              followedShopId: _followedShopId,
              onFollowPressed: (shopId) async => await CustomerHandler.handleFollowShop(shopId),
              onUnFollowPressed: (followedShopId) async => await CustomerHandler.handleUnFollowShop(followedShopId),
              onFollowChanged: (followedShopId) {
                setState(() {
                  _followedShopId = followedShopId;
                });
              },
              showFollowedCount: true,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              onPressed: () => context.push('${ShopPage.path}/${_productDetail.shopId}'),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
      expandedHeight: 300,
      floating: false,
      pinned: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white24),
        ),
      ),
      actions: const [
        CartBadge(),
        SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(imageUrl: _productDetail.product.image),
              ),
            );
          },
          child: ImageCacheable(
            _productDetail.product.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Rating, sold, count-favorite, add-to-favorite btn
  IntrinsicHeight _buildMoreInfo() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Rating(rating: double.parse(_productDetail.product.rating)),
              const VerticalDivider(
                color: Colors.grey,
                width: 20,
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
              Text('${_productDetail.product.sold} đã bán'),
              const VerticalDivider(
                color: Colors.grey,
                width: 20,
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
              FutureBuilder(
                future: sl<ProductRepository>().getProductCountFavorite(_productDetail.product.productId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final resultEither = snapshot.data!;
                    return resultEither.fold(
                      (error) => MessageScreen.error(error.message),
                      (ok) => Text('${ok.data} lượt thích'),
                    );
                  } else if (snapshot.hasError) {
                    return MessageScreen.error(snapshot.error.toString());
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),

          // Add to favorite button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.unauthenticated) return const SizedBox();
              return FutureBuilder(
                  future: sl<ProductRepository>().favoriteProductCheckExist(
                    widget.productId ?? widget.productDetail!.product.productId,
                  ),
                  builder: (context, snapshot) {
                    final favoriteProductId = snapshot.data?.fold(
                      (error) {
                        Fluttertoast.showToast(msg: 'error: ${error.message}');
                        return null;
                      },
                      (ok) => ok.data?.favoriteProductId,
                    );
                    return IconButton(
                      icon: favoriteProductId != null
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                      onPressed: () => handleTapFavoriteButton(favoriteProductId),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Column(
      children: [
        DividerWithText(
          text: 'Thông tin sản phẩm',
          color: Colors.grey[300],
          centerText: true,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '# Phân loại: ${_productDetail.categoryName}',
          ),
        ), //category
        Text(
          _productDetail.product.information,
          maxLines: _isShowMoreInformation ? null : 4,
          overflow: _isShowMoreInformation ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        if (_productDetail.product.description.length > 100)
          TextButton(
            onPressed: () {
              setState(() {
                _isShowMoreInformation = !_isShowMoreInformation;
              });
            },
            child: Text(
              _isShowMoreInformation ? 'Thu gọn' : 'Xem thêm thông tin',
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        DividerWithText(
          text: 'Mô tả sản phẩm',
          color: Colors.grey[300],
          centerText: true,
        ),
        Text(
          _productDetail.product.description,
          maxLines: _isShowMoreDescription ? null : 4,
          overflow: _isShowMoreDescription ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        if (_productDetail.product.description.length > 100)
          TextButton(
            onPressed: () {
              setState(() {
                _isShowMoreDescription = !_isShowMoreDescription;
              });
            },
            child: Text(
              _isShowMoreDescription ? 'Thu gọn' : 'Xem thêm mô tả',
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductPrice() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _productDetail.product.cheapestPrice != _productDetail.product.mostExpensivePrice
            ? '${ConversionUtils.formatCurrency(_productDetail.product.cheapestPrice)} - ${ConversionUtils.formatCurrency(_productDetail.product.mostExpensivePrice)}'
            : ConversionUtils.formatCurrency(_productDetail.product.cheapestPrice),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildProductName() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _productDetail.product.name,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ignore: unused_element
  Align _buildProductImage(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewPage(imageUrl: _productDetail.product.image),
            ),
          );
        },
        child: SizedBox(
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                _productDetail.product.image,
                fit: BoxFit.fitWidth,
              ),
              // back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.white.withOpacity(0.6),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // favorite button
              // Positioned(
              //   top: 16,
              //   right: 16,
              //   child: IconButton(
              //     style: ButtonStyle(
              //       backgroundColor: WidgetStateProperty.all(
              //         Colors.white.withOpacity(0.6),
              //       ),
              //     ),
              //     icon: _favoriteProductId != null ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
              //     onPressed: handleTapFavoriteButton,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom action bar with buttons:
  // - Chat
  // - Add to cart
  // - Buy now
  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: IconTextButton(
              onPressed: () async => await CustomerHandler.navigateToChatPage(context, shopId: _productDetail.shopId),
              buttonStyle: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
              ),
              leadingIcon: Icons.chat_outlined,
              // backgroundColor: Colors.grey[200],
              label: 'Chat',
              fontSize: 12,
              iconSize: 18,
              // borderRadius: BorderRadius.zero,
              reverseDirection: true,
            ),
          ),
          Expanded(
            flex: 3,
            child: IconTextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return SheetAddToCartOrBuyNow(product: _productDetail.product);
                  },
                );
              },
              buttonStyle: IconButton.styleFrom(
                backgroundColor: Theme.of(context).buttonTheme.colorScheme?.tertiaryContainer,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
              ),
              // backgroundColor: Theme.of(context).buttonTheme.colorScheme?.tertiaryContainer,
              leadingIcon: Icons.shopping_cart_outlined,
              label: 'Thêm vào giỏ hàng',
              fontSize: 12,
              iconSize: 18,
              // borderRadius: BorderRadius.zero,
              reverseDirection: true,
            ),
          ),
          Expanded(
            flex: 5,
            child: IconTextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return SheetAddToCartOrBuyNow(product: _productDetail.product, isBuyNow: true);
                  },
                );
              },
              buttonStyle: IconButton.styleFrom(
                backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              // backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
              leadingIcon: Icons.attach_money_outlined,
              label: 'Mua ngay',
              fontSize: 14,
              iconSize: 20,
              // borderRadius: BorderRadius.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionProducts() {
    return Column(
      children: [
        DividerWithText(
          text: 'Sản phẩm tương tự',
          color: Colors.grey[300],
          centerText: true,
        ),
        NestedLazyLoadBuilder<ProductEntity>(
          controller: _lazyController,
          crossAxisCount: 2,
          itemBuilder: (context, __, data) {
            return ProductItem(
              // product: _lazyController.items[index],
              product: data,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetailPage(productId: data.productId);
                    },
                  ),
                );
              },
            );
          },
          dataCallback: (page) => sl<ProductRepository>().getSuggestionProductsRandomlyByAlikeProduct(
            page,
            6,
            _productDetail.product.productId,
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildProductReview() {
    return FutureBuilder(
      future: sl<ProductRepository>().getProductReviews(_productDetail.product.productId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final resultEither = snapshot.data!;
          return resultEither.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => Column(
              children: [
                DividerWithText(
                  text: 'Đánh giá sản phẩm',
                  color: Colors.grey[300],
                  centerText: true,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Rating(
                        rating: double.parse(_productDetail.product.rating),
                        showRatingBar: true,
                        showRatingText: false,
                      ),
                      Text(
                        '(${ok.data!.count} đánh giá)',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey[200], indent: 32, endIndent: 32, height: 8),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                    color: Colors.grey.withOpacity(0.5),
                    indent: 32,
                    endIndent: 32,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ok.data!.reviews.length > 3 ? 3 : ok.data!.reviews.length, // show only 3 reviews
                  itemBuilder: (context, index) {
                    return ReviewItem(ok.data!.reviews[index]);
                  },
                ),

                // show all reviews button
                if (ok.data!.reviews.length > 3)
                  TextButton(
                    onPressed: () {
                      context.go(ProductReviewsPage.path, extra: _productDetail.product.productId);
                    },
                    child: const Text(
                      'Xem tất cả đánh giá',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
