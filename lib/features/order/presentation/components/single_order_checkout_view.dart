import 'package:flutter/material.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../domain/repository/voucher_repository.dart';
import '../pages/voucher_page.dart';

///- shop info
///- items
///- shop voucher
///- shipping method
///- single order payment
/// - note
class SingleOrderCheckoutView extends StatelessWidget {
  SingleOrderCheckoutView({
    super.key,
    required this.orderDetail,
    required OrderRequestWithCartParam param,
    required this.onOrderRequestChanged,
    required this.onNoteChanged,
    required this.onUseLoyaltyPointChanged,
    required this.showUseLoyaltyPoint,
  })  : _placeOrderWithCartParam = param,
        _order = orderDetail.order;

  final OrderDetailEntity orderDetail;
  final void Function(OrderRequestWithCartParam param) onOrderRequestChanged;
  final void Function(bool multiParam) onUseLoyaltyPointChanged;
  final void Function(String param) onNoteChanged;
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
        OrderSectionShopItems(
          order: _order,
          shopVoucherCode: _placeOrderWithCartParam.shopVoucherCode,
          onShopVoucherPressed: () async {
            final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
              builder: (context) {
                return VoucherPage(
                  returnValue: true,
                  future: sl<VoucherRepository>().listOnShop(_order.shop.shopId),
                );
              },
            ));

            if (voucher != null) {
              if (_placeOrderWithCartParam.shopVoucherCode != voucher.code) {
                onOrderRequestChanged(
                  _placeOrderWithCartParam.copyWith(shopVoucherCode: voucher.code),
                );
              }
            }
          },
        ),
        const SizedBox(height: 8),

        //! shipping method
        OrderSectionShippingMethod(orderShippingMethod: orderDetail.order.shippingMethod, orderShippingFee: orderDetail.order.shippingFee),
        const SizedBox(height: 8),

        //! loyalty point
        if (showUseLoyaltyPoint) ...[
          OrderSectionLoyaltyPoint(
            totalPoint: orderDetail.totalPoint!,
            isUsingLoyaltyPoint: _placeOrderWithCartParam.useLoyaltyPoint,
            onChanged: (value) {
              onUseLoyaltyPointChanged(value);
            },
          ),
          const SizedBox(height: 8),
        ],

        //! total price
        OrderSectionSingleOrderPayment(order: _order),
        const SizedBox(height: 8),

        //! note
        OrderSectionNote(
          note: _placeOrderWithCartParam.note,
          onChanged: (value) {
            onNoteChanged(value);
          },
        ),
      ],
    );
  }
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
