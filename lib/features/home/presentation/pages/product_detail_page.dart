import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/pages/photo_view.dart';
import '../../domain/entities/product_entity.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(
      //   context,
      //   title: product.name,
      //   showSearchBar: false,
      //   automaticallyImplyLeading: true,
      // ),
      bottomSheet: _showBottomSheet ? _buildBtnAddToCartAndBuyNow(context) : null,
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
            Align(
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
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // name of the product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // price of the product
            Padding(
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
            ),

            const SizedBox(height: 16),

            // description of the product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            // button to add to cart
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       showModalBottomSheet(
            //         context: context,
            //         isDismissible: true,
            //         showDragHandle: true,
            //         isScrollControlled: true,
            //         builder: (context) {
            //           return BottomSheetAddToCart(product: product);
            //         },
            //       );
            //     },
            //     child: const Text('Add to cart'),
            //   ),
            // ),

            // list product variants
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: product.productVariant.length,
            //   itemBuilder: (context, index) {
            //     final variant = product.productVariant[index];
            //     return ListTile(
            //       title: Text(variant.productName),
            //       subtitle: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('productVariantId: ${variant.productVariantId}'),
            //           Text('sku: ${variant.sku}'),
            //           Text('quantity: ${variant.quantity}'),
            //           Text('originalPrice: ${variant.originalPrice}'),
            //           Text('attributes: ${variant.attributes.toString()}'),
            //           Text('price: ${formatCurrency(variant.price)}'),
            //         ],
            //       ),
            //       leading: CircleAvatar(
            //         backgroundImage: NetworkImage(
            //           variant.image.isNotEmpty ? variant.image : product.image,
            //         ),
            //       ),
            //       trailing: IconButton(
            //         icon: const Icon(Icons.add),
            //         onPressed: () async {
            //           // final resultEither = await sl<CartRepository>().addToCart(variant.productVariantId, 1);
            //           // resultEither.fold(
            //           //   (l) => log('error: $l'),
            //           //   (r) => log('success: $r'),
            //           // );
            //           context.read<CartBloc>().add(AddToCart(variant.productVariantId, 1));
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtnAddToCartAndBuyNow(BuildContext context) {
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
