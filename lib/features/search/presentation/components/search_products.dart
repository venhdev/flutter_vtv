import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/search/domain/repository/search_product_repository.dart';

import '../../../../service_locator.dart';

import '../../../home/domain/repository/product_repository.dart';
import 'product_item.dart';

class SearchProducts extends StatelessWidget {
  final String? keywords;

  const SearchProducts({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách sản phẩm tìm kiếm',
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
          future: sl<SearchProductRepository>()
              .searchPageProductBySort(1, 10, keywords ?? '', 'newest'),
          // Pass keywords parameter
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (errorResp) => Center(
                  child: Text('Error: $errorResp',
                      style: const TextStyle(color: Colors.red)),
                ),
                (productDTOResp) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: productDTOResp.data.products
                      .map(
                        (product) => ProductItem(product: product),
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
