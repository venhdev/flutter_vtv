import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/components/custom_buttons.dart';
import '../../../../core/presentation/pages/photo_view.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
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
  const ProductDetailPage({super.key, required this.product});

  final ProductEntity product;

  static const String routeName = 'product-detail';
  static const String path = '/home/product-detail';

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _showBottomSheet = true;
  int? _favoriteProductId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    checkIsFavorite();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _showBottomSheet) {
      setState(() {
        _showBottomSheet = false;
      });
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_showBottomSheet) {
      setState(() {
        _showBottomSheet = true;
      });
    }
  }

  void handleTapFavoriteButton() async {
    // add to favorite
    if (_favoriteProductId == null) {
      final respEither = await sl<ProductRepository>().favoriteProductAdd(widget.product.productId);

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
    final checkEither = await sl<ProductRepository>().favoriteProductCheckExist(widget.product.productId);
    log('checkEither: $checkEither');

    setState(() {
      _favoriteProductId = checkEither.fold(
        (error) => null,
        (ok) => ok.data?.favoriteProductId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: _showBottomSheet ? _buildBottomActionBar(context) : null,
      bottomSheet: _buildBottomActionBar(context),
      body: GestureDetector(
        onTap: () {
          if (!_showBottomSheet) {
            setState(() {
              _showBottomSheet = true;
            });
          }
        },
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            // image of the product
            _buildProductImage(context),

            const SizedBox(height: 16),

            // name of the product
            _buildProductName(),

            const SizedBox(height: 8),

            // price of the product
            _buildProductPrice(),

            const SizedBox(height: 16),

            // description of the product
            _buildProductDescription(),

            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  Padding _buildProductDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.product.description,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Padding _buildProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.product.cheapestPrice != widget.product.mostExpensivePrice
            ? '${formatCurrency(widget.product.cheapestPrice)} - ${formatCurrency(widget.product.mostExpensivePrice)}'
            : formatCurrency(widget.product.cheapestPrice),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Padding _buildProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.product.name,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Align _buildProductImage(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewPage(imageUrl: widget.product.image),
            ),
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.product.image,
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
                    return SheetAddToCartOrBuyNow(product: widget.product);
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
                    return SheetAddToCartOrBuyNow(product: widget.product, isBuyNow: true);
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
}
