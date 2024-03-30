import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../../profile/domain/entities/address_dto.dart';
import '../../domain/dto/place_order_param.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../components/order_status_badge.dart';
import '../components/shop_info.dart';

// const String _noVoucherMsg = 'Không áp dụng';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.order,
  });

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  final OrderEntity order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPage();
}

class _OrderDetailPage extends State<OrderDetailPage> {
  late AddressEntity _address; // just ID
  late OrderEntity _order;
  // Properties sent to the server
  late PlaceOrderParam _placeOrderParam;

  Future<T?> showDialogToChangeAddress<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogChooseAddress(
          onAddressChanged: (address) {
            reloadOrder(_placeOrderParam.copyWith(addressId: address.addressId), newAddress: address);
            // setState(() {
            //   _address = address;
            //   _placeOrderParam = _placeOrderParam.copyWith(addressId: address.addressId);
            // });
          },
        );
      },
    );
  }

  Future<void> reloadOrder(PlaceOrderParam newOrderParam, {AddressEntity? newAddress}) async {
    final respEither = await sl<OrderRepository>().createUpdateWithCart(newOrderParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: 'Lỗi: ${error.message}');
      },
      (ok) {
        setState(() {
          _placeOrderParam = newOrderParam;
          if (newAddress != null) {
            _address = newAddress;
          }
          _order = ok.data.order;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _address = widget.order.address;
    _order = widget.order;

    _placeOrderParam = PlaceOrderParam(
      addressId: widget.order.address.addressId,
      systemVoucherCode: null,
      shopVoucherCode: null,
      useLoyaltyPoint: false,
      paymentMethod: widget.order.paymentMethod,
      shippingMethod: widget.order.shippingMethod,
      note: '',
      cartIds: widget.order.orderItems.map((e) => e.cartId).toList(),
    );
  }

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
                if (_placeOrderParam.note.isNotEmpty) _buildNote(),
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
          OrderStatusBadge(status: _order.status),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return Text('Lời nhắn: ${_placeOrderParam.note}');
    // return TextField(
    //   style: const TextStyle(fontSize: 14),
    //   decoration: const InputDecoration(
    //     hintText: 'Ghi chú',
    //     enabledBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.grey),
    //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //     ),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //     ),
    //   ),
    //   onChanged: (value) {
    //     setState(() {
    //       _placeOrderParam = _placeOrderParam.copyWith(note: value);
    //     });
    //   },
    // );
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
          _totalSummaryPriceItem('Tổng tiền hàng:', _order.totalPrice),
          _totalSummaryPriceItem('Phí vận chuyển:', _order.shippingFee),

          if (_placeOrderParam.systemVoucherCode != null)
            _totalSummaryPriceItem('Giảm giá hệ thống:', _order.discountSystem),
          if (_placeOrderParam.shopVoucherCode != null)
            _totalSummaryPriceItem('Giảm giá cửa hàng:', _order.discountShop),

          // total price
          const Divider(thickness: 0.2, height: 4),
          _totalSummaryPriceItem(
            'Tổng thanh toán:',
            _order.paymentTotal,
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
          // Text(_order.paymentMethod),
          Text(formatPaymentMethod(_order.paymentMethod)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return AddressSummary(
      address: _address,
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
          Text(_order.shippingMethod),
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems() {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(shop: _order.shop),

          //! list of items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _order.orderItems.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            itemBuilder: (context, index) {
              final item = _order.orderItems[index];
              return OrderItem(item);
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildShopVoucherBtn() {
  //   return GestureDetector(
  //     onTap: () async {
  //       final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
  //         builder: (context) {
  //           return VoucherPage(
  //             returnValue: true,
  //             future: sl<VoucherRepository>().listOnShop(_order.shop.shopId.toString()),
  //           );
  //         },
  //       ));

  //       if (voucher != null) {
  //         reloadOrder(
  //           _placeOrderParam.copyWith(shopVoucherCode: voucher.code),
  //         );
  //       }
  //     },
  //     child: Text(
  //       _placeOrderParam.shopVoucherCode ?? _noVoucherMsg,
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       textAlign: TextAlign.end,
  //       style: TextStyle(
  //         color: _placeOrderParam.shopVoucherCode == null ? Colors.grey : Colors.green,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
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
