import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../../home/presentation/pages/shop_page.dart';
import '../../domain/repository/order_repository.dart';
import '../components/btn/review_btn.dart';
import 'customer_order_detail_page.dart';

class CustomerOrderPurchasePage extends StatelessWidget {
  const CustomerOrderPurchasePage({super.key});

  static const String routeName = OrderPurchasePage.routeName;
  static const String path = OrderPurchasePage.path;

  @override
  Widget build(BuildContext context) {
    return OrderPurchasePage.customer(
      pageController: OrderPurchasePageController(tapPages: [
        OrderStatus.PENDING,
        OrderStatus.PROCESSING,
        OrderStatus.SHIPPING,
        OrderStatus.DELIVERED,
        OrderStatus.COMPLETED,
        OrderStatus.WAITING,
        OrderStatus.CANCEL,
      ]),
      // dataCallback: CustomerHandler.dataCallOrderPurchasePage,
      dataCallback: (status) {
        if (status == null) {
          return sl<OrderRepository>().getListOrders();
        } else if (status == OrderStatus.PROCESSING) {
          // combine 2 lists of orders with status PROCESSING and PICKUP_PENDING
          return sl<OrderRepository>().getListOrdersByStatusProcessingAndPickupPending();
        } else if (status == OrderStatus.WAITING) {
          return sl<OrderRepository>().getListOrdersByMultiStatus([OrderStatus.UNPAID, OrderStatus.WAITING]);
        }
        return sl<OrderRepository>().getListOrdersByStatus(status.name);
      },
      customerItemBuilder: (order, onRefresh) => OrderPurchaseItem(
        order: order,
        onPressed: () {
          CustomerHandler.navigateToOrderDetailPage(context, orderId: order.orderId!);
        },
        onShopPressed: () => context.push('${ShopPage.path}/${order.shop.shopId}'),
        actionBuilder: (status) => _buildOrderStatusAction(
          context,
          order: order,
          onRefresh: onRefresh,
          // onReceivedPressed: onReceivedCallback,
        ),
      ),
    );
  }
}

Widget _buildOrderStatusAction(
  BuildContext context, {
  required OrderEntity order,
  required VoidCallback onRefresh,
}) {
  if (order.status == OrderStatus.DELIVERED) {
    return OrderPurchaseItemAction(
      label: 'Bạn đã nhận được hàng chưa?',
      buttonLabel: 'Đã nhận',
      onPressed: () async {
        final resultEither = await completeOrder(context, order.orderId!);
        resultEither?.fold(
          (error) {
            Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi hoàn tất đơn hàng!');
            onRefresh(); // maybe old data
          },
          (ok) => onRefresh(),
        );
      },
    );
  } else if (order.status == OrderStatus.COMPLETED) {
    return CustomerReviewButton(order: order);
  }
  return const SizedBox.shrink();
}

// Future<void> navigateToOrderDetailPage(
//   BuildContext context,
//   OrderEntity order,
//   void Function(OrderDetailEntity)? onReceivedCallback, //use when user tap completed order in OrderDetailPage
// ) async {
//   final respEither = await sl<OrderRepository>().getOrderDetail(order.orderId!);
//   respEither.fold(
//     (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
//     (ok) async {
//       final completedOrder = await context.push<OrderDetailEntity>(CustomerOrderDetailPage.path, extra: ok.data);
//       if (completedOrder != null && onReceivedCallback != null) onReceivedCallback(completedOrder);
//     },
//   );
// }
