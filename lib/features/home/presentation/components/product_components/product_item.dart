import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/presentation/components/image_cacheable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go(ProductDetailPage.route, extra: product);
        },
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: ImageCacheable(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${product.name} ${product.name}${product.name}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            // Text(
            //   product.cheapestPrice != product.mostExpensivePrice
            //       ? '${formatCurrency(product.cheapestPrice)} - ${formatCurrency(product.mostExpensivePrice)}'
            //       : formatCurrency(product.cheapestPrice),
            // ),
            Text(formatCurrency(product.cheapestPrice)),
          ],
        ),
      ),
    );
  }
}
