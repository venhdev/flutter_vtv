import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import 'product_item.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách sản phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Xem thêm'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder(
          future: sl<ProductRepository>().getSuggestionProductsRandomly(1, 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (errorResp) => Center(
                  child: Text('Error: $errorResp', style: const TextStyle(color: Colors.red)),
                ),
                (productDTOResp) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: productDTOResp.data.products
                      .map(
                        (product) => ProductItem(
                          title: product.name,
                          image: product.image,
                          price: product.productVariant.first.price,
                        ),
                      )
                      .toList(),
                ),
              );
            }

            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          },
        ),
      ],
    );
  }
}
