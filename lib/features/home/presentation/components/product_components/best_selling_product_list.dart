import 'package:flutter/material.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../../../core/presentation/components/image_cacheable.dart';
import '../../../domain/dto/product_dto.dart';
import '../../../domain/entities/product_entity.dart';
import '../../pages/product_detail_page.dart';

class BestSellingProductListBuilder extends StatelessWidget {
  const BestSellingProductListBuilder({
    super.key,
    required this.future,
  });

  final FRespData<ProductDTO> Function() future;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản phẩm bán chạy',
          textAlign: TextAlign.left, // Align the text to the left
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder<RespData<ProductDTO>>(
          future: future(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class BestSellingProductItem extends StatelessWidget {
  const BestSellingProductItem({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
    this.height = 70,
  });

  final String title;
  final String image;
  final double height;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageCacheable(
              image,
              height: height,
              fit: BoxFit.fitHeight,
              borderRadius: BorderRadius.circular(6.0),
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
