import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import 'product_detail_page.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({
    super.key,
    required this.productId,
  });

  static const String routeName = 'review';
  static const String path = '/home/product/review';

  final int productId;

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem Đánh giá'),
      ),
      body: FutureBuilder(
        future: sl<ProductRepository>().getReviewProduct(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resultEither = snapshot.data!;

            return resultEither.fold(
              (error) => MessageScreen.error(error.toString()),
              (ok) => ListView.builder(
                itemCount: ok.data.reviews.length,
                itemBuilder: (context, index) {
                  final review = ok.data.reviews[index];
                  return ReviewItem(review);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
