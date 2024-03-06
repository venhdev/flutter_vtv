import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/pages/photo_view.dart';
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
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent,
      ),
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
                  height: MediaQuery.of(context).size.height * 0.5,
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
                formatCurrency(product.productVariant.first.price),
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

            // button to add to cart (always align at bottom of the screen)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // add to cart
                  },
                  child: const Text('Add to cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
