import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines/timelines.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../../home/presentation/pages/product_detail_page.dart';
import '../components/btn/review_btn.dart';
import '../components/checkout/wrapper.dart';
import '../components/order_status_badge.dart';

// const String _noVoucherMsg = 'Không áp dụng';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    super.key,
    required this.orderDetail,
    required this.onCompleteOrderPressed,
    required this.onCancelOrderPressed,
    required this.onRePurchasePressed,
  });

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  final OrderDetailEntity orderDetail;

  //! Customer view
  final Future<void> Function(String orderId) onCompleteOrderPressed;
  final Future<void> Function(String orderId) onCancelOrderPressed;
  final Future<void> Function(List<OrderItemEntity> orderItems) onRePurchasePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      bottomSheet: _buildBottomActionByOrderStatus(context, orderDetail.order.status),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //! order status 'mã đơn hàng' + 'ngày đặt hàng' + copy button
              Wrapper(
                // backgroundColor: Colors.red.shade100,
                backgroundColor: ColorHelper.getOrderStatusBackgroundColor(orderDetail.order.status, shade: 100),
                child: Column(
                  children: [
                    // order date + order id
                    _buildOrderInfo(),
                    // status
                    _buildOrderStatus(),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              //# summary info: transport + shipping method + order timeline
              _buildSummaryInfo(),
              const SizedBox(height: 8),

              //! order summary
              _buildShopInfoAndItems(context), // shop info, list of items
              const SizedBox(height: 8),

              //! payment method
              _buildPaymentMethod(),
              const SizedBox(height: 8),

              //! total price
              _buildTotalPrice(),
              const SizedBox(height: 8),

              //! note
              _buildNote(),

              //? cancel button -> move to bottom sheet
              // if (orderDetail.order.status == OrderStatus.PENDING || orderDetail.order.status == OrderStatus.PROCESSING)
              //   _buildCancelButton(context),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildOrderInfo() {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            // 'Ngày đặt hàng',
            TextSpan(text: 'Ngày đặt hàng:\n', children: [
              TextSpan(
                text: StringHelper.convertDateTimeToString(
                  (orderDetail.order.orderDate).toLocal(),
                  pattern: 'dd-MM-yyyy hh:mm aa',
                ),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ]),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    text: 'Mã đơn hàng: ',
                    style: const TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: orderDetail.order.orderId.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Icon(Icons.copy),
              IconButton(
                icon: const Icon(Icons.copy),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: orderDetail.order.orderId.toString()));
                  Fluttertoast.showToast(msg: 'Đã sao chép mã đơn hàng');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryInfo() {
    return Wrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Thông tin vận chuyển',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          text: 'Mã vận đơn: ',
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: orderDetail.transport!.transportId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // child: Text.rich(
                      //   'Mã vận đơn:',
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(fontSize: 12)
                      // ),
                    ),
                    //btn copy
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: orderDetail.transport!.transportId));
                        Fluttertoast.showToast(msg: 'Đã sao chép mã vận đơn');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          _buildShippingMethod(),
          const SizedBox(height: 2),
          _buildDeliveryAddress(),
          Timeline.tileBuilder(
            padding: const EdgeInsets.all(8),
            theme: TimelineThemeData(nodePosition: 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // reverse: false,
            builder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        StringHelper.convertDateTimeToString(
                          orderDetail.transport!.transportHandleDtOs[index].createAt,
                          pattern: 'dd-MM-yyyy\nHH:mm',
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '(${orderDetail.transport!.transportHandleDtOs[index].transportStatus}) ${orderDetail.transport!.transportHandleDtOs[index].messageStatus}',
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: orderDetail.transport!.transportHandleDtOs.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Column(
      children: [
        //# order status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trạng thái đơn hàng',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            OrderStatusBadge(status: orderDetail.order.status),
          ],
        ),
      ],
    );
  }

  Widget _buildNote() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          text: 'Ghi chú: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: orderDetail.order.note ?? '(không có)',
              style: TextStyle(
                color: orderDetail.order.note == null ? Colors.grey : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tổng cộng',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          _totalSummaryPriceItem('Tổng tiền hàng:', orderDetail.order.totalPrice),
          _totalSummaryPriceItem('Phí vận chuyển:', orderDetail.order.shippingFee),

          _totalSummaryPriceItem('Giảm giá hệ thống:', orderDetail.order.discountSystem),
          _totalSummaryPriceItem('Giảm giá cửa hàng:', orderDetail.order.discountShop),

          if (orderDetail.order.loyaltyPointHistory != null) ...[
            _totalSummaryPriceItem(
              'Giảm giá điểm tích lũy:',
              orderDetail.order.loyaltyPointHistory!.point,
            ),
          ],

          // total price
          const Divider(thickness: 0.2, height: 4),
          _totalSummaryPriceItem(
            'Tổng thanh toán:',
            orderDetail.order.paymentTotal,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _totalSummaryPriceItem(String title, int price, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          StringHelper.formatCurrency(price),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Wrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Phương thức thanh toán',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(widget.order.paymentMethod),
          Text(StringHelper.getPaymentName(orderDetail.order.paymentMethod)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return AddressSummary(
      address: orderDetail.order.address,
      color: Colors.white,
      suffixIcon: null,
    );
  }

  Widget _buildShippingMethod() {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Phương thức vận chuyển',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // method name
          Text(orderDetail.order.shippingMethod),
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems(BuildContext context) {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo.viewOnly(
            shopId: orderDetail.order.shop.shopId,
            shopName: orderDetail.order.shop.name,
            shopAvatar: orderDetail.order.shop.avatar,
          ),
          const SizedBox(height: 8),

          //! list of items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderDetail.order.orderItems.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            itemBuilder: (context, index) {
              final item = orderDetail.order.orderItems[index];
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailPage(productId: item.productVariant.productId);
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: OrderItem(item),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomActionByOrderStatus(BuildContext context, OrderStatus status) {
    final isVender = context.read<AuthCubit>().state.auth!.userInfo.roles!.contains(Role.VENDOR);

    Widget buildByStatus(BuildContext context, OrderStatus status) {
      switch (status) {
        case OrderStatus.PENDING || OrderStatus.PROCESSING:
          return ActionButton.cancelOrder(() => onCancelOrderPressed(orderDetail.order.orderId!));
        case OrderStatus.COMPLETED:
          return ReviewBtn(order: orderDetail.order);
        case OrderStatus.CANCEL:
          return ActionButton.rePurchase(() => onRePurchasePressed(orderDetail.order.orderItems));
        case OrderStatus.PICKUP_PENDING || OrderStatus.SHIPPING:
          return ActionButton.back(context);
        case OrderStatus.DELIVERED:
          return ActionButton.completeOrder(() => onCompleteOrderPressed(orderDetail.order.orderId!));

        default:
          throw UnimplementedError('Not implement for status: $status');
      }
    }

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: !isVender
          //! Customer view
          ? Row(
              children: [
                //# chat
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: ActionButton.chat(null)),
                      if (status == OrderStatus.COMPLETED)
                        Expanded(
                            flex: 2,
                            child: ActionButton.rePurchase(() => onRePurchasePressed(orderDetail.order.orderItems))),
                    ],
                  ),
                ),

                //# cancel - add review - view review
                Expanded(
                  child: buildByStatus(context, status),
                ),
              ],
            )
          //! Vendor view
          : ActionButton.back(context),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  factory ActionButton.back(BuildContext context) => ActionButton(
        label: 'Quay lại',
        onPressed: () => context.pop(),
        backgroundColor: Colors.grey.shade400,
      );
  factory ActionButton.completeOrder(void Function()? onCompleteOrderPressed) => ActionButton(
        label: 'Đã nhận được hàng',
        onPressed: onCompleteOrderPressed,
        backgroundColor: Colors.green.shade300,
      );
  factory ActionButton.cancelOrder(void Function()? onCancelOrderPressed) => ActionButton(
        label: 'Hủy đơn hàng',
        onPressed: onCancelOrderPressed,
        backgroundColor: Colors.red.shade300,
      );
  factory ActionButton.rePurchase(void Function()? onRePurchasePressed) => ActionButton(
        label: 'Mua lại',
        onPressed: onRePurchasePressed,
        backgroundColor: Colors.green.shade300,
      );
  factory ActionButton.chat(void Function()? onChatPressed) => ActionButton(
        label: 'Chat',
        onPressed: onChatPressed,
        backgroundColor: Colors.blue.shade300,
      );

  final String label;
  final void Function()? onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
