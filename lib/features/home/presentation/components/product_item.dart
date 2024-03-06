import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // context.go('/home/product-detail', extra: product);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: Image.network(product.image),
            ),
            Text(product.name),
            Text(formatCurrency(product.productVariant.first.price)),
          ],
        ),
      ),
    );
  }
}
