import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/components/app_bar.dart';
import '../../../../core/presentation/pages/photo_view.dart';
import '../../../../service_locator.dart';
import '../../../cart/domain/repository/cart_repository.dart';
import '../../domain/entities/product_entity.dart';

//! this page should use to easily pop back to the previous screen
/*
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ),
  );
*/
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.name),
      //   backgroundColor: Colors.transparent,
      // ),
      appBar: buildAppBar(context, title: product.name, showSearchBar: false, automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // image of the product
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewPage(imageUrl: product.image),
                    ),
                  );
                },
                child: Image.network(
                  product.image,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // name of the product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.name,
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
                product.cheapestPrice != product.mostExpensivePrice
                    ? '${formatCurrency(product.cheapestPrice)} - ${formatCurrency(product.mostExpensivePrice)}'
                    : formatCurrency(product.cheapestPrice),
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
                product.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // list product variants
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: product.productVariant.length,
              itemBuilder: (context, index) {
                final variant = product.productVariant[index];
                return ListTile(
                  title: Text(variant.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('productVariantId: ${variant.productVariantId}'),
                      Text('sku: ${variant.sku}'),
                      Text('quantity: ${variant.quantity}'),
                      Text('originalPrice: ${variant.originalPrice}'),
                      Text('attributes: ${variant.attributes.toString()}'),
                      Text(formatCurrency(variant.price)),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      variant.image.isNotEmpty ? variant.image : product.image,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final resultEither = await sl<CartRepository>().addToCart(variant.productVariantId, 1);
                      resultEither.fold(
                        (l) => log('error: $l'),
                        (r) => log('success: $r'),
                      );
                    },
                  ),
                );
              },
            ),

            // button to add to cart (always align at bottom of the screen)
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // add to cart
            //       },
            //       child: const Text('Add to cart'),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
