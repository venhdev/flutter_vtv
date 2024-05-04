import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../home/presentation/pages/product_detail_page.dart';
import '../components/btn/review_btn.dart';

class CustomerOrderDetailPage extends StatelessWidget {
  const CustomerOrderDetailPage({super.key, required this.orderDetail});

  final OrderDetailEntity orderDetail;

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  @override
  Widget build(BuildContext context) {
    return OrderDetailPage.customer(
      orderDetail: orderDetail,
      onRePurchasePressed: (orderItems) => CustomerHandler.rePurchaseOrder(context, orderItems),
      onCancelOrderPressed: (orderId) => CustomerHandler.cancelOrder(context, orderId),
      onCompleteOrderPressed: (orderId) => CustomerHandler.completeOrder(
        context,
        orderId,
        inOrderDetailPage: true,
      ),
      customerReviewBtn: (order) => ReviewBtn(order: order),
      onOrderItemPressed: (orderItem) => context.push(
        ProductDetailPage.path,
        extra: orderItem.productVariant.productId,
      ),
    );
  }
}
