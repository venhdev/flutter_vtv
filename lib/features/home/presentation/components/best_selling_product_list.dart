import 'package:flutter/material.dart';

import '../../../../core/constants/typedef.dart';
import '../../domain/dto/product_dto.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail_page.dart';
import 'category_list.dart';

class BestSellingProductList extends StatelessWidget {
  const BestSellingProductList({
    super.key,
    required this.future,
  });

  final FRespData<ProductDTO> Function() future;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Sản phẩm bán chạy',
            textAlign: TextAlign.left, // Align the text to the left
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder<RespData<ProductDTO>>(
          future: future(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (err) => Center(
                  child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
                ),
                (ok) => SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ok.data.products.length,
                    itemBuilder: (context, index) {
                      final ProductEntity product = ok.data.products[index];
                      return BestSellingProductItem(
                        title: product.name,
                        image: product.image,
                        height: 90,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(product: product),
                            ),
                          );
                        },
                      );
                    },
                    // children: ok.data.products
                    //     .map(
                    //       (product) => CategoryItem(
                    //         title: product.name,
                    //         image: product.image,
                    //         height: 150,
                    //       ),
                    //     )
                    //     .toList(),
                  ),
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
