import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../../service_locator.dart';
import '../../../../home/domain/repository/product_repository.dart';
import '../../pages/order_reviews_page.dart';
import '../../pages/add_review_page.dart';

class ReviewBtn extends StatelessWidget {
  const ReviewBtn({
    super.key,
    required this.order,
    this.labelNotReview,
  });

  final OrderEntity order;
  final String? labelNotReview;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<ProductRepository>().isOrderReviewed(order),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => ok
                ? ElevatedButton(
                    onPressed: () {
                      context.push(OrderReviewsPage.path, extra: order);
                    },
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Xem đánh giá'),
                  )
                : IconTextButton(
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const RoundedRectangleBorder(),
                    ),
                    // child: Text('Đánh giá sản phẩm'),
                    label: labelNotReview ?? 'Đánh giá sản phẩm',
                    leadingIcon: Icons.warning_amber_rounded,
                    iconSize: 20,
                    iconColor: Colors.redAccent,
                    onPressed: () {
                      context.push(ReviewAddPage.path, extra: order);
                    },
                  ),
          );
        }
        return const Text(
          'Đang tải...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        );
      },
    );
  }
}
