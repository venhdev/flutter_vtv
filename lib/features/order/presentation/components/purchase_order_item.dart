import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../domain/entities/order_entity.dart';
import '../pages/order_detail_page.dart';
import 'order_status_badge.dart';
import 'shop_info.dart';

class PurchaseOrderItem extends StatelessWidget {
  const PurchaseOrderItem({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(OrderDetailPage.path, extra: order);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShopInfo(shop: order.shop),
                const Spacer(),
                OrderStatusBadge(status: order.status),
              ],
            ),
            OrderItem(order.orderItems.first),
            if (order.orderItems.length > 1)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  '+ ${order.orderItems.length - 1} sản phẩm khác',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),
              ),
            // Sum order items + totalPayment
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.orderItems.length} sản phẩm'),
                  Text('Tổng thanh toán: ${formatCurrency(order.paymentTotal)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
