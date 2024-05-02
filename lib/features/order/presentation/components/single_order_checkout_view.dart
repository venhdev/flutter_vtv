import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';
import 'package:vtv_common/shop.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../domain/repository/voucher_repository.dart';
import '../pages/voucher_page.dart';
import 'total_payment_item.dart';

const String _noVoucherMsg = 'Chọn hoặc nhập mã';

class SingleCheckoutView extends StatelessWidget {
  SingleCheckoutView({
    super.key,
    required this.orderDetail,
    required OrderRequestWithCartParam param,
    required this.onOrderRequestChangedAtIndex,
    required this.onLocalNoteOrderRequestChanged,
    required this.onUseLoyaltyPointChanged,
    required this.showUseLoyaltyPoint,
  })  : _placeOrderWithCartParam = param,
        _order = orderDetail.order;
  // _address = orderDetail.order.address;

  final OrderDetailEntity orderDetail;
  final void Function(OrderRequestWithCartParam param) onOrderRequestChangedAtIndex;
  final void Function(bool multiParam) onUseLoyaltyPointChanged;
  final void Function(String param) onLocalNoteOrderRequestChanged;
  // render data
  final OrderRequestWithCartParam _placeOrderWithCartParam;
  final OrderEntity _order;
  final bool showUseLoyaltyPoint;
  // final AddressEntity _address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! order summary
        _buildShopInfoAndItems(context), // shop info, list of items
        const SizedBox(height: 8),

        // address
        // _buildDeliveryAddress(context),
        // const SizedBox(height: 8),

        //! shipping method
        _buildShippingMethod(),
        const SizedBox(height: 8),

        // //! payment method
        // _buildPaymentMethod(),
        // const SizedBox(height: 8),

        // voucher
        // _buildSystemVoucherBtn(context),
        // const SizedBox(height: 8),

        //! loyalty point
        if (showUseLoyaltyPoint) ...[
          _buildLoyaltyPoint(),
          const SizedBox(height: 8),
        ],

        //! total price
        _buildTotalPrice(),
        const SizedBox(height: 8),

        //! note
        _buildNote(),
      ],
    );
  }

  Widget _buildLoyaltyPoint() {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sử dụng điểm tích lũy', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Điểm hiện có: ${orderDetail.totalPoint}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: _placeOrderWithCartParam.useLoyaltyPoint,
            onChanged: (value) {
              onUseLoyaltyPointChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return TextField(
      style: const TextStyle(fontSize: 14),
      controller: TextEditingController(text: _placeOrderWithCartParam.note),
      decoration: const InputDecoration(
        hintText: 'Ghi chú',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: TextStyle(color: Colors.grey),
        // border: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.red,
        //   ),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey),
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        // ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        // ),
      ),
      onChanged: (value) {
        onLocalNoteOrderRequestChanged(value);
        // _placeOrderWithCartParam = _placeOrderWithCartParam.copyWith(note: value);
      },
    );
  }

  Widget _buildTotalPrice() {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tổng cộng',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TotalPaymentItem(
            label: 'Tổng tiền hàng:',
            price: StringHelper.formatCurrency(_order.totalPrice),
          ),
          TotalPaymentItem(
            label: 'Phí vận chuyển:',
            price: StringHelper.formatCurrency(_order.shippingFee),
          ),

          if (_placeOrderWithCartParam.systemVoucherCode != null)
            TotalPaymentItem(
              label: 'Giảm giá hệ thống:',
              price: StringHelper.formatCurrency(_order.discountSystem),
            ),
          if (_placeOrderWithCartParam.shopVoucherCode != null)
            TotalPaymentItem(
              label: 'Giảm giá cửa hàng:',
              price: StringHelper.formatCurrency(_order.discountShop),
            ),

          //? not null means using loyalty point
          if (_order.loyaltyPointHistory != null) ...[
            //? maybe negative point >> no need to add '-' sign
            TotalPaymentItem(
              label: 'Sử dụng điểm tích lũy:',
              price: StringHelper.formatCurrency(_order.loyaltyPointHistory!.point),
            ),
          ],

          // total price,
          const Divider(thickness: 0.2, height: 4),
          TotalPaymentItem(
            label: 'Tổng số tiền:',
            price: StringHelper.formatCurrency(_order.paymentTotal),
            priceStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Wrapper(
      label: const WrapperLabel(icon: Icons.payment, labelText: 'Phương thức thanh toán'),
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_order.paymentMethod),
              Text(StringHelper.getPaymentName(_order.paymentMethod)),
            ],
          )
        ],
      ),
    );
  }

  // Widget _buildDeliveryAddress(BuildContext context) {
  //   return AddressSummary(
  //     address: _address,
  //     onTap: () => showDialogToChangeAddress(context, (address) {
  //       onOrderRequestChangedAtIndex(
  //         _placeOrderWithCartParam.copyWith(addressId: address.addressId),
  //       );
  //     }),
  //   );
  // }

  Widget _buildShippingMethod() {
    return Wrapper(
      label: const WrapperLabel(icon: Icons.local_shipping, labelText: 'Phương thức vận chuyển'),
      suffixLabel: Text(_order.shippingMethod),
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Phí vận chuyển:',
          ),
          Text(StringHelper.formatCurrency(_order.shippingFee)),
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems(BuildContext context) {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade300),
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(
            shopId: _order.shop.shopId,
            shopName: _order.shop.name,
            shopAvatar: _order.shop.avatar,
            hideAllButton: true,
          ),

          const SizedBox(height: 8),

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

          //! Shop voucher
          Wrapper(
            label: const WrapperLabel(icon: Icons.card_giftcard, labelText: 'Mã giảm giá của Shop'),
            suffixLabel: _buildShopVoucherBtn(context),
            useBoxShadow: false,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(top: 8),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Expanded(
            //       child: Text(
            //         'Mã giảm giá cửa hàng',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: _buildShopVoucherBtn(context),
            //     ),
            //   ],
            // ),
          ),
          // const Divider(thickness: 0.4, height: 8),
        ],
      ),
    );
  }

  Widget _buildShopVoucherBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
          builder: (context) {
            return VoucherPage(
              returnValue: true,
              future: sl<VoucherRepository>().listOnShop(_order.shop.shopId.toString()),
            );
          },
        ));

        if (voucher != null) {
          onOrderRequestChangedAtIndex(
            _placeOrderWithCartParam.copyWith(shopVoucherCode: voucher.code),
          );
        }
      },
      child: Text(
        _placeOrderWithCartParam.shopVoucherCode ?? _noVoucherMsg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: _placeOrderWithCartParam.shopVoucherCode == null ? Colors.grey : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget _buildSystemVoucherBtn(BuildContext context) {
  //   return InkWell(
  //     onTap: () async {
  //       // show dialog to choose voucher
  //       final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
  //         builder: (context) {
  //           // return const VoucherPage(returnValue: true);
  //           return VoucherPage(
  //             returnValue: true,
  //             future: sl<VoucherRepository>().listOnSystem(),
  //           );
  //         },
  //       ));

  //       if (voucher != null) {
  //         onOrderRequestChangedAtIndex(
  //           _placeOrderWithCartParam.copyWith(systemVoucherCode: voucher.code),
  //         );
  //       }
  //     },
  //     overlayColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.2)),
  //     child: Wrapper(
  //       useBoxShadow: false,
  //       border: Border.all(color: Colors.grey.shade300),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           const Text(
  //             'Mã giảm giá',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             _placeOrderWithCartParam.systemVoucherCode ?? _noVoucherMsg,
  //             style: TextStyle(
  //               color: _placeOrderWithCartParam.systemVoucherCode == null ? Colors.grey : Colors.green,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

Future<T?> showDialogToChangeAddress<T>(BuildContext context, void Function(AddressEntity) onAddressChanged) {
  return showDialog(
    context: context,
    builder: (context) {
      // onAddressChanged: (address) {
      //   widget.onOrderRequestChanged(
      //     _placeOrderWithCartParam.copyWith(addressId: address.addressId),
      //   );
      // },
      return DialogChooseAddress(onAddressChanged: onAddressChanged);
    },
  );
}
