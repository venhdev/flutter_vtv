import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../../home/presentation/pages/shop_page.dart';
import '../../domain/repository/order_repository.dart';
import '../pages/order_detail_page.dart';
import 'btn/review_btn.dart';
import 'order_status_badge.dart';

class PurchaseOrderItem extends StatelessWidget {
  const PurchaseOrderItem({
    super.key,
    required this.order,
    required this.onReceived,
  });

  final OrderEntity order;

  /// when user confirm received order (status = DELIVERED)
  final void Function(OrderDetailEntity completedOrder) onReceived;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final respEither = await sl<OrderRepository>().getOrderDetail(order.orderId!);
        respEither.fold(
          (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
          (ok) async {
            final completedOrder = await context.push<OrderDetailEntity>(OrderDetailPage.path, extra: ok.data);
            if (completedOrder != null) onReceived(completedOrder);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            //# shop info + order status
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ShopInfo(
                    shopId: order.shop.shopId,
                    shopName: order.shop.name,
                    shopAvatar: order.shop.avatar,
                    onPressed: () => context.push('${ShopPage.path}/${order.shop.shopId}'),
                  ),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),

            //# show the first order item
            const SizedBox(height: 8),
            OrderItem(order.orderItems.first),
            if (order.orderItems.length > 1)
              Text(
                '+ ${order.orderItems.length - 1} sản phẩm khác',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            //# Sum order items + totalPayment
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
                  Text('Tổng thanh toán: ${StringHelper.formatCurrency(order.paymentTotal)}'),
                ],
              ),
            ),

            //# order status = DELIVERED show button to confirm received
            const SizedBox(height: 8),
            if (order.status == OrderStatus.DELIVERED) _buildReceivedBtn(context),
            if (order.status == OrderStatus.COMPLETED)
              ReviewBtn(order: order, labelNotReview: 'Bạn chưa đánh giá sản phẩm'),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Bạn đã nhận được hàng chưa?'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.green.shade400,
            ),
            onPressed: () async {
              final isConfirm = await showDialogToConfirm<bool>(
                context: context,
                title: 'Bạn đã nhận được hàng?',
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                content:
                    'Hành động này không thể hoàn tác. Sau khi xác nhận, bạn sẽ không thể yêu cầu hoàn trả tiền hoặc đổi trả hàng. Và chúng tôi sẽ chuyển tiền cho người bán.',
                confirmText: 'Xác nhận',
                confirmBackgroundColor: Colors.green.shade300,
                dismissText: 'Thoát',
              );

              if (isConfirm ?? false) {
                final respEither = await sl<OrderRepository>().completeOrder(order.orderId!);
                respEither.fold(
                  (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
                  (ok) {
                    onReceived(ok.data!);
                    context.go(OrderDetailPage.path, extra: ok.data);
                  },
                );
              }
            },
            child: const Text('Đã nhận hàng', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
