import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/order/domain/dto/multiple_order_request_param.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/entities/multiple_order_resp.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/single_order_checkout_view.dart';
import '../components/total_payment_item.dart';
import 'voucher_page.dart';

//! This page is used to checkout multiple orders at once

class CheckoutMultipleOrderPage extends StatefulWidget {
  const CheckoutMultipleOrderPage({
    super.key,
    required this.multiOrderResp,
  });

  static const String routeName = 'multi-checkout';
  static const String path = '/home/cart/multi-checkout';

  final MultipleOrderResp multiOrderResp;

  @override
  State<CheckoutMultipleOrderPage> createState() => _CheckoutMultipleOrderPageState();
}

class _CheckoutMultipleOrderPageState extends State<CheckoutMultipleOrderPage> {
  late MultipleOrderRequestParam _multipleOrderRequestParam;
  late MultipleOrderResp _multiOrderResp;

  Future<void> handleChangedOrderRequest(MultipleOrderRequestParam multiParam) async {
    final respEither = await sl<OrderRepository>().createMultiOrderByRequest(multiParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Đã xảy ra lỗi khi tạo đơn hàng');
      },
      (ok) {
        setState(() {
          _multipleOrderRequestParam = multiParam;
          _multiOrderResp = ok.data!;
        });
      },
    );
  }

  Future<void> handleChangedOrderRequestAtIndex(OrderRequestWithCartParam param, int index) async {
    final tempParam = _multipleOrderRequestParam.copyWithIndex(param: param, index: index);
    final respEither = await sl<OrderRepository>().createMultiOrderByRequest(tempParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Đã xảy ra lỗi khi tạo đơn hàng');
      },
      (ok) {
        setState(() {
          _multipleOrderRequestParam = tempParam;
          _multiOrderResp = ok.data!;
        });
      },
    );
  }

  void handlePlaceOrder() async {
    Future<T?> showConfirmationDialog<T>() async {
      return await showDialogToConfirm(
        context: context,
        title: 'Xác nhận đặt hàng',
        content: 'Bạn có chắc chắn muốn đặt hàng?',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        confirmText: 'Xác nhận',
        dismissText: 'Hủy',
        confirmBackgroundColor: Colors.green.shade200,
        dismissBackgroundColor: Colors.grey.shade400,
      );
    }

    final isConfirmed = await showConfirmationDialog<bool>();

    if (isConfirmed ?? false) {
      final respEither = await sl<OrderRepository>().placeMultiOrderByRequest(_multipleOrderRequestParam);

      respEither.fold(
        (error) {
          showDialogToAlert(
            context,
            title: const Text('Đặt hàng thất bại'),
            children: [
              Text(error.message ?? 'Đã xảy ra lỗi khi đặt hàng'),
            ],
          );
        },
        (ok) async {
          context.read<CartBloc>().add(const FetchCart());
          showDialogToAlert(
            context,
            title: const Text('Đặt hàng thành công'),
          ).then((_) => context.go(OrderPurchasePage.path));
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _multipleOrderRequestParam = MultipleOrderRequestParam.fromOrderDetails(widget.multiOrderResp);
    _multiOrderResp = widget.multiOrderResp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _address(context),
                for (var i = 0; i < widget.multiOrderResp.orderDetails.length; i++)
                  Wrapper(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: SingleCheckoutView(
                      orderDetail: _multiOrderResp.orderDetails[i],
                      onOrderRequestChangedAtIndex: (param) => handleChangedOrderRequestAtIndex(param, i),
                      onUseLoyaltyPointChanged: (isUse) {
                        _multipleOrderRequestParam.setUseLoyaltyPoint(isUse, i); // update value
                        handleChangedOrderRequest(_multipleOrderRequestParam); // re-fetch data
                      },
                      onLocalNoteOrderRequestChanged: (note) {
                        _multipleOrderRequestParam.changeNote(index: i, note: note);
                      },
                      param: _multipleOrderRequestParam.orderRequestWithCarts[i],
                      showUseLoyaltyPoint: ((_multipleOrderRequestParam.loyaltyPointIndex == i) ||
                              (_multipleOrderRequestParam.loyaltyPointIndex == null)) &&
                          _multiOrderResp.orderDetails.first.totalPoint! > 0,
                    ),
                  ),

                // payment method
                Wrapper(
                  label: const WrapperLabel(icon: Icons.payment, labelText: 'Phương thức thanh toán'),
                  useBoxShadow: false,
                  border: Border.all(color: Colors.grey.shade300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_multipleOrderRequestParam.paymentMethod),
                          Text(StringHelper.getPaymentName(_multipleOrderRequestParam.paymentMethod)),
                        ],
                      )
                    ],
                  ),
                ),

                // system voucher code
                Wrapper(
                  onPressed: () async {
                    // show dialog to choose voucher
                    final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
                      builder: (context) {
                        // return const VoucherPage(returnValue: true);
                        return VoucherPage(
                          returnValue: true,
                          future: sl<VoucherRepository>().listOnSystem(),
                        );
                      },
                    ));

                    // _multipleOrderRequestParam.setSystemVoucherCode = voucher.code;

                    if (voucher != null) {
                      // onOrderRequestChangedAtIndex(
                      //   _placeOrderWithCartParam.copyWith(systemVoucherCode: voucher.code),
                      // );
                      _multipleOrderRequestParam.setSystemVoucherCode = voucher.code;
                      handleChangedOrderRequest(_multipleOrderRequestParam);
                    }
                  },
                  margin: EdgeInsets.zero,
                  label: const WrapperLabel(
                    icon: Icons.card_giftcard,
                    labelText: 'Mã giảm giá hệ thống',
                    iconColor: Colors.orange,
                  ),
                  suffixLabel: Text(
                    // _placeOrderWithCartParam.systemVoucherCode ?? _noVoucherMsg,
                    _multipleOrderRequestParam.systemVoucherCode ?? 'Chưa chọn mã giảm giá',
                    style: TextStyle(
                      color: _multipleOrderRequestParam.systemVoucherCode == null ? Colors.grey : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _totalPayment(),
                _buildPlaceOrderBottomSheet(context)
              ],
            ),
          ),
          // _buildPlaceOrderBottomSheet(context)
        ],
      ),
    );
  }

  Widget _address(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: AddressSummary(
        address: _multiOrderResp.orderDetails.first.order.address,
        onTap: () => showDialogToChangeAddress(context, (address) {
          if (address.addressId != _multipleOrderRequestParam.addressId) {
            _multipleOrderRequestParam.setAddressId(address.addressId);
            handleChangedOrderRequest(_multipleOrderRequestParam);
          }
        }),
      ),
    );
  }

  Wrapper _totalPayment() {
    return Wrapper(
      label: WrapperLabel(
        icon: Icons.payments,
        labelText: 'Chi tiết thanh toán (${_multiOrderResp.totalQuantity} sản phẩm)',
        iconColor: Colors.green,
      ),
      child: Column(
        children: [
          TotalPaymentItem(
            label: 'Tổng tiền hàng:',
            price: StringHelper.formatCurrency(_multiOrderResp.totalPrice),
          ),
          TotalPaymentItem(
            label: 'Tổng tiền phí vận chuyển:',
            price: StringHelper.formatCurrency(_multiOrderResp.totalShippingFee),
          ),
          if (_multiOrderResp.totalLoyaltyPoint != 0)
            TotalPaymentItem(
              label: 'Sử dụng điểm tích lũy:',
              price: _multiOrderResp.totalLoyaltyPoint.toString(),
            ),
          if (_multiOrderResp.discountShop != 0)
            TotalPaymentItem(
              label: 'Tổng giảm giá từ cửa hàng:',
              price: StringHelper.formatCurrency(_multiOrderResp.discountShop),
            ),
          if (_multiOrderResp.discountSystem != 0)
            TotalPaymentItem(
              label: 'Tổng giảm giá từ hệ thống:',
              price: StringHelper.formatCurrency(_multiOrderResp.discountSystem),
            ),
          TotalPaymentItem(
            label: 'Tổng thanh toán:',
            price: StringHelper.formatCurrency(_multiOrderResp.totalPayment),
            priceStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBottomSheet(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Tổng thanh toán: '),
        Text(
          // StringHelper.formatCurrency(
          //   _orderDetails.fold(0, (acc, orderDetail) => acc + orderDetail.order.paymentTotal),
          // ), //acc: accumulator
          StringHelper.formatCurrency(_multiOrderResp.totalPayment),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed: handlePlaceOrder,
          child: const Text('Đặt hàng'),
        ),
      ],
    );
  }
}

//! Một số lỗi cần fix:
//- tuy là multi-order nhưng bản chất là các order đơn lẻ được gom lại 1 lần
//> tốn voucher
//> điểm tích lũy chỉ sài được cho một order --các order còn lại để trống
