import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../auth/presentation/components/rating.dart';
import '../../../cart/presentation/components/cart_badge.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/product_item.dart';
import '../components/product_components/sheet_add_to_cart_or_buy_now.dart';

//! this page should use to easily pop back to the previous screen
/*
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ),
  );
*/
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    this.productId,
    this.productDetail,
  })  : assert(productId != null || productDetail != null, 'productId or productDetail must not be null'),
        assert(productId == null || productDetail == null, 'cannot pass both productId and productDetail');

  final int? productId;
  final ProductDetailResp? productDetail;

  static const String routeName = 'product-detail';
  static const String path = '/home/product-detail';

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late LazyLoadController<ProductEntity> _lazyController;
  // bool _showBottomSheet = true;
  int? _favoriteProductId;
  bool _isShowMoreDescription = false;

  bool isInitializing = true;
  late ProductDetailResp _productDetail;

  void fetchProductDetail(int id) async {
    final respEither = await sl<ProductRepository>().getProductDetailById(id);

    respEither.fold(
      (error) => log('Error: ${error.message}'),
      (ok) {
        setState(() {
          _productDetail = ok.data;
          isInitializing = false;
        });
      },
    );
  }

  void handleTapFavoriteButton() async {
    // add to favorite
    if (_favoriteProductId == null) {
      final respEither = await sl<ProductRepository>().favoriteProductAdd(_productDetail.product.productId);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã thêm vào yêu thích');
          setState(() {
            _favoriteProductId = ok.data.favoriteProductId;
          });
        },
      );
    } else {
      final respEither = await sl<ProductRepository>().favoriteProductDelete(_favoriteProductId!);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã xóa khỏi yêu thích');
          setState(() {
            _favoriteProductId = null;
          });
        },
      );
    }
  }

  void checkIsFavorite() async {
    // final isFavorite = await sl<ProductRepository>().isFavoriteProduct(widget.product.productId);
    final checkEither = await sl<ProductRepository>().favoriteProductCheckExist(
      widget.productId ?? widget.productDetail!.product.productId,
    );

    setState(() {
      _favoriteProductId = checkEither.fold(
        (error) => null,
        (ok) => ok.data?.favoriteProductId,
      );
    });
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

  @override
  void dispose() {
    _lazyController.scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
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
      isInitializing = false;
    }
    checkIsFavorite();
    cacheRecentView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: _showBottomSheet ? _buildBottomActionBar(context) : null,
      bottomSheet: _buildBottomActionBar(context),
      // onTap: () {
      //     if (!_showBottomSheet) {
      //       setState(() {
      //         _showBottomSheet = true;
      //       });
      //     }
      //   },
      body: isInitializing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                fetchProductDetail(widget.productId!);
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

              const SizedBox(height: 56),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShopInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_productDetail.shopAvatar),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _productDetail.shopName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      floating: false,
      pinned: true,
      snap: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white24),
        ),
      ),
      actions: const [CartBadge(pushOnNav: true), SizedBox(width: 8)],
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
            ],
          ),

          // Add to favorite button
          IconButton(
            icon: _favoriteProductId != null
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
            onPressed: handleTapFavoriteButton,
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
        Text(
          _productDetail.product.information,
          style: const TextStyle(fontSize: 14),
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
        if (_productDetail.product.description.length > 50)
          TextButton(
            onPressed: () {
              setState(() {
                _isShowMoreDescription = !_isShowMoreDescription;
              });
            },
            child: Text(
              _isShowMoreDescription ? 'Thu gọn' : 'Xem thêm',
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductPrice() {
    return Text(
      _productDetail.product.cheapestPrice != _productDetail.product.mostExpensivePrice
          ? '${StringHelper.formatCurrency(_productDetail.product.cheapestPrice)} - ${StringHelper.formatCurrency(_productDetail.product.mostExpensivePrice)}'
          : StringHelper.formatCurrency(_productDetail.product.cheapestPrice),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.red,
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      _productDetail.product.name,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
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
          height: MediaQuery.of(context).size.height * 0.4,
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
                    backgroundColor: MaterialStateProperty.all(
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
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.6),
                    ),
                  ),
                  icon: _favoriteProductId != null ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                  onPressed: handleTapFavoriteButton,
                ),
              ),
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
              onPressed: () {
                // TODO: open chat
              },
              icon: Icons.chat_outlined,
              backgroundColor: Colors.grey[200],
              label: 'Chat',
              fontSize: 12,
              iconSize: 18,
              borderRadius: BorderRadius.zero,
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
              backgroundColor: Theme.of(context).buttonTheme.colorScheme?.tertiaryContainer,
              icon: Icons.shopping_cart_outlined,
              label: 'Thêm vào giỏ hàng',
              fontSize: 12,
              iconSize: 18,
              borderRadius: BorderRadius.zero,
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
              backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
              icon: Icons.attach_money_outlined,
              label: 'Mua ngay',
              fontSize: 14,
              iconSize: 20,
              borderRadius: BorderRadius.zero,
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
          itemBuilder: (context, index, data) {
            return ProductItem(
              product: _lazyController.items[index],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetailPage(productId: _lazyController.items[index].productId);
                    },
                  ),
                );
              },
            );
          },
          // scrollController: (execute) {
          //   _scrollController.addListener(() {
          //     log('Scroll position: ${_scrollController.position.pixels}');
          //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          //       execute();
          //     }
          //   });
          //   return _scrollController;
          // },
          // scrollController: _scrollController,

          dataCallback: (page) => sl<ProductRepository>().getSuggestionProductsRandomlyByAlikeProduct(
            page,
            6,
            _productDetail.product.productId,
            false,
          ),
        ),
      ],
    );
    // return FutureBuilder(
    //   future: sl<ProductRepository>().getSuggestionProductsRandomlyByAlikeProduct(
    //     1,
    //     5,
    //     _productDetail.product.productId,
    //     false,
    //   ),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       final resultEither = snapshot.data!;
    //       return resultEither.fold(
    //         (error) => MessageScreen.error(error.message),
    //         (ok) => ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: ok.data.products.length,
    //           itemBuilder: (context, index) {
    //             return ProductItem(
    //               product: ok.data.products[index],
    //               onPressed: () {},
    //             );
    //           },
    //         ),
    //       );
    //     } else if (snapshot.hasError) {
    //       return MessageScreen.error(snapshot.error.toString());
    //     }
    //     return MessageScreen(message: snapshot.hasData.toString());
    //   },
    // );
  }

  Widget _buildProductReview() {
    return FutureBuilder(
      future: sl<ProductRepository>().getReviewProduct(_productDetail.product.productId),
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
                        '(${ok.data.count} đánh giá)',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey[200], indent: 32, endIndent: 32, height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ok.data.reviews.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //# user info + rating
                        ListTile(
                          leading: const CircleAvatar(
                            // backgroundImage: NetworkImage(ok.data.reviews[index].userAvatar),
                            backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
                          ),
                          title: Text(ok.data.reviews[index].username),
                          subtitle: Rating(rating: double.parse(ok.data.reviews[index].rating.toString())),
                        ),

                        //# review content
                        Text(ok.data.reviews[index].content),

                        //# review image
                        if (ok.data.reviews[index].image != null)
                          SizedBox(
                            height: 100,
                            child: ImageCacheable(
                              ok.data.reviews[index].image!,
                              fit: BoxFit.cover,
                            ),
                          ),

                        //# date
                        Text(
                          StringHelper.convertDateTimeToString(
                            ok.data.reviews[index].createdAt,
                            pattern: 'dd-MM-yyyy HH:mm',
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
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
