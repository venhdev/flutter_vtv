import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/product_entity.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go('/home/product-detail', extra: product);
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
