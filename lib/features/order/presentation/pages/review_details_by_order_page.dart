import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../domain/dto/add_review_dto.dart';
import '../components/sheet_add_or_update_review.dart';

//Show review of order items in an order
class ReviewDetailsByOrderPage extends StatefulWidget {
  const ReviewDetailsByOrderPage({super.key, required this.order});

  static const String routeName = 'review-detail';
  static const String path = '/user/purchase/order-detail/review-detail';

  final OrderEntity order;

  @override
  State<ReviewDetailsByOrderPage> createState() => _ReviewDetailsByOrderPageState();
}

class _ReviewDetailsByOrderPageState extends State<ReviewDetailsByOrderPage> {
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
          listParam = reviews
              .map((e) => ReviewParam(
                    content: e.content,
                    rating: e.rating,
                    orderItemId: e.orderItemId,
                    imagePath: e.image,
                    hasImage: e.image?.isNotEmpty ?? false,
                    reviewId: e.reviewId,
                  ))
              .toList();
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
          : Column(
              children: [
                // list of items to review
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: widget.order.orderItems.length,
                    itemBuilder: (context, index) => Column(
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
                ),
              ],
            ),
    );
  }
}
