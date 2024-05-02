import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../home/presentation/pages/shop_page.dart';

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
      dataCallback: CustomerHandler.dataCallOrderPurchasePage,
      customerItemBuilder: (order, onReceivedCallback) => OrderPurchaseItem(
        order: order,
        onPressed: () => CustomerHandler.navigateToOrderDetailPage(context, order, onReceivedCallback),
        onShopPressed: () => context.push('${ShopPage.path}/${order.shop.shopId}'),
        actionBuilder: (status) => CustomerHandler.buildOrderStatusAction(
          context,
          order: order,
          onReceivedPressed: onReceivedCallback,
        ),
      ),
    );
  }
}
