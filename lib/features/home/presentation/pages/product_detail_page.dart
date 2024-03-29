import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/pages/photo_view.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/sheet_add_to_cart.dart';

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
  bool _isFavorite = false;
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
    if (!_isFavorite) {
      final respEither = await sl<ProductRepository>().addFavoriteProduct(widget.product.productId);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã thêm vào yêu thích');
          setState(() {
            _isFavorite = true;
          });
        },
      );
    } else {
      final respEither = await sl<ProductRepository>().removeFavoriteProduct(widget.product.productId);

      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Đã xóa khỏi yêu thích');
          setState(() {
            _isFavorite = false;
          });
        },
      );
    }
  }

  void checkIsFavorite() async {
    final isFavorite = await sl<ProductRepository>().isFavoriteProduct(widget.product.productId);
    setState(() {
      _isFavorite = isFavorite != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _showBottomSheet ? _buildBottomActionBar(context) : null,
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
                  icon: _isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                  // icon: FutureBuilder(
                  //     future: sl<ProductRepository>().isFavoriteProduct(widget.product.productId),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         final isFavorite = snapshot.data;

                  //         if (isFavorite != null) {
                  //           return isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border);
                  //         } else {
                  //           return const Icon(Icons.favorite_border);
                  //         }
                  //       }
                  //       // return const Icon(Icons.favorite_border);
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }),
                  onPressed: handleTapFavoriteButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom action bar with buttons:
  /// - Add to cart
  /// - Buy now
  Widget _buildBottomActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (context) {
                  return BottomSheetAddToCart(product: widget.product);
                },
              );
            },
            child: const Text('Thêm vào giỏ hàng'),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              // buy now
            },
            child: const Text('Mua ngay'),
          ),
        ),
      ],
    );
  }
}
