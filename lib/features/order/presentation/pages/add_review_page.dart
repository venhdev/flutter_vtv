import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../domain/dto/review_param.dart';
import '../components/sheet_add_or_update_review.dart';

class ReviewAddPage extends StatelessWidget {
  const ReviewAddPage({super.key, required this.order});

  static const String routeName = 'review-add';
  static const String path = '/user/purchase/order-detail/review-add';

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    var listParam = List<ReviewParam>.generate(
        order.orderItems.length,
        (index) => ReviewParam(
              content: '',
              rating: 5,
              orderItemId: order.orderItems[index].orderItemId!,
              imagePath: null,
              hasImage: false,
            ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
      ),
      body: Column(
        children: [
          // list of items to review
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: order.orderItems.length,
              itemBuilder: (context, index) => Column(
                children: [
                  // item info
                  ListTile(
                    leading: Image.network(order.orderItems[index].productVariant.image.isNotEmpty
                        ? order.orderItems[index].productVariant.image
                        : order.orderItems[index].productVariant.productImage),
                    title: Text(order.orderItems[index].productVariant.productName),
                    subtitle: Text('Số lượng: ${order.orderItems[index].quantity}'),
                    // trailing: Text(
                    //   '${order.orderItems[index].price}đ',
                    //   style: const TextStyle(fontWeight: FontWeight.bold),
                    // ),
                  ),
                  SheetAddOrUpdateReview(
                    orderItemId: order.orderItems[index].orderItemId!,
                    initParam: listParam[index],
                    onChange: (value) {
                      log('value: ${value.toString()}');
                      listParam[index] = value;
                    },
                  ),
                ],
              ),
            ),
          ),

          // submit button
          ElevatedButton(
            onPressed: () {
              // submit review
              if (listParam.any((review) => review.content.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'Vui lòng nhập đánh giá cho tất cả sản phẩm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: Colors.redAccent,
                ));
                return;
              }

              sl<ProductRepository>().addReviews(listParam).then((either) {
                either.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(failure.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  },
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Cảm ơn bạn đã đánh giá sản phẩm'),
                      // backgroundColor: Theme.of(context).colorScheme.success,
                    ));
                  },
                );
                Navigator.of(context).pop();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Text('Gửi đánh giá'),
          ),
        ],
      ),
    );
  }
}
