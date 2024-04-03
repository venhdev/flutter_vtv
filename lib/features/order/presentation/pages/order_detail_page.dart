import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/helpers.dart';

import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../domain/dto/order_detail_entity.dart';
import '../components/order_status_badge.dart';
import '../components/shop_info.dart';

// const String _noVoucherMsg = 'Không áp dụng';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderDetail});

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  final OrderDetailEntity orderDetail;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPage();
}

class _OrderDetailPage extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //! order status
                _buildOrderStatus(),
                const SizedBox(height: 8),

                //! address
                _buildDeliveryAddress(),
                const SizedBox(height: 8),

                //! order summary
                _buildShopInfoAndItems(), // shop info, list of items
                const SizedBox(height: 8),

                //! shipping method
                _buildShippingMethod(),
                const SizedBox(height: 8),

                //! payment method
                _buildPaymentMethod(),
                const SizedBox(height: 8),

                //! total price
                _buildTotalPrice(),
                const SizedBox(height: 8),

                //! note
                _buildNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Wrapper _buildOrderStatus() {
    return Wrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Trạng thái đơn hàng',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          OrderStatusBadge(status: widget.orderDetail.order.status),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return Wrapper(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ghi chú',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.orderDetail.order.note ?? '(không có)',
          style: TextStyle(
            color: widget.orderDetail.order.note == null ? Colors.grey : Colors.black,
          ),
        ),
      ],
    ));
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
          _totalSummaryPriceItem('Tổng tiền hàng:', widget.orderDetail.order.totalPrice),
          _totalSummaryPriceItem('Phí vận chuyển:', widget.orderDetail.order.shippingFee),

          _totalSummaryPriceItem('Giảm giá hệ thống:', widget.orderDetail.order.discountSystem),
          _totalSummaryPriceItem('Giảm giá cửa hàng:', widget.orderDetail.order.discountShop),

          // total price
          const Divider(thickness: 0.2, height: 4),
          _totalSummaryPriceItem(
            'Tổng thanh toán:',
            widget.orderDetail.order.paymentTotal,
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
          formatCurrency(price),
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
          Text(formatPaymentMethod(widget.orderDetail.order.paymentMethod)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return AddressSummary(
      address: widget.orderDetail.order.address,
      color: Colors.white,
      suffixIcon: null,
      border: null,
    );
  }

  Widget _buildShippingMethod() {
    return Wrapper(
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
          Text(widget.orderDetail.order.shippingMethod),
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems() {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(shop: widget.orderDetail.order.shop),

          //! list of items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.orderDetail.order.orderItems.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            itemBuilder: (context, index) {
              final item = widget.orderDetail.order.orderItems[index];
              return OrderItem(item);
            },
          ),
        ],
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
