import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../domain/dto/review_param.dart';
import '../components/sheet_add_or_update_review.dart';

// Show review in an order (for all items), customer can:
// - View all reviews that they have made
// - Update their review (DELETE)
class OrderReviewsPage extends StatefulWidget {
  const OrderReviewsPage({super.key, required this.order});

  static const String routeName = 'order-review';
  static const String path = '/user/purchase/order-detail/order-review';

  final OrderEntity order;

  @override
  State<OrderReviewsPage> createState() => _OrderReviewsPageState();
}

class _OrderReviewsPageState extends State<OrderReviewsPage> {
  late bool _loading;
  late List<ReviewParam> listParam;

  void _fetchData() {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    sl<ProductRepository>().getAllReviewDetailByOrder(widget.order).then((either) {
      either.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(failure.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        },
        (reviews) {
          // listParam = reviews.map((e) {
          //   if (e.status == Status.DELETED) return ReviewParam.empty();

          //   return ReviewParam(
          //     content: e.content,
          //     rating: e.rating,
          //     orderItemId: e.orderItemId,
          //     imagePath: e.image,
          //     hasImage: e.image?.isNotEmpty ?? false,
          //     reviewId: e.reviewId,
          //   );
          // }).toList();

          listParam = [];

          for (var review in reviews) {
            // if (review.status == Status.ACTIVE) {
              listParam.add(ReviewParam(
                content: review.content,
                rating: review.rating,
                orderItemId: review.orderItemId,
                imagePath: review.image,
                hasImage: review.image?.isNotEmpty ?? false,
                reviewId: review.reviewId,
                isDeleted: review.status == Status.DELETED,
              ));
            // }
          }
        },
      );

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: widget.order.orderItems.length,
              itemBuilder: (context, index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // item info
                  ListTile(
                    leading: Image.network(widget.order.orderItems[index].productVariant.image.isNotEmpty
                        ? widget.order.orderItems[index].productVariant.image
                        : widget.order.orderItems[index].productVariant.productImage),
                    title: Text(widget.order.orderItems[index].productVariant.productName),
                    subtitle: Text('Số lượng: ${widget.order.orderItems[index].quantity}'),
                  ),
                  SheetAddOrUpdateReview(
                    orderItemId: widget.order.orderItems[index].orderItemId!,
                    initParam: listParam[index],
                    onChange: (value) {
                      listParam[index] = value;
                    },
                    isAdding: false, //> view only
                  ),
                ],
              ),
            ),
    );
  }
}
