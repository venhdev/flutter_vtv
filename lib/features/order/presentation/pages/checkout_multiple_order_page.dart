import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/dto/multiple_order_request_param.dart';
import '../../domain/dto/webview_payment_param.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/dialog_to_confirm_checkout.dart';
import '../components/single_order_checkout_view.dart';
import 'vnpay_webview.dart';
import 'voucher_page.dart';

//! This page is used to checkout multiple orders at once
//! Một số lỗi cần fix:
//- tuy là multi-order nhưng bản chất là các order đơn lẻ được gom lại 1 lần
//> tốn voucher
//> điểm tích lũy chỉ sài được cho một order --các order còn lại để trống

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

  void handlePlaceMultiOrder() async {
    final isConfirmed = await showDialogToConfirmCheckout<bool>(context);

    if (isConfirmed ?? false) {
      final respEither = await sl<OrderRepository>().placeMultiOrderByRequest(_multipleOrderRequestParam);

      respEither.fold(
        (error) {
          context.read<CartBloc>().add(const FetchCart()); // refresh cart even if error
          showDialogToAlert(context, title: const Text('Đặt hàng thất bại'), children: [
            Text(error.message ?? 'Đã xảy ra lỗi khi đặt hàng'),
          ]);
        },
        (ok) async {
          context.read<CartBloc>().add(const FetchCart()); // refresh cart
          //! Online Payment
          if (_multipleOrderRequestParam.paymentMethod != PaymentTypes.COD) {
            //# VNPay
            if (_multipleOrderRequestParam.paymentMethod == PaymentTypes.VNPay) {
              await handleVNPay(ok);
            } else if (_multipleOrderRequestParam.paymentMethod == PaymentTypes.Wallet) {
              if (ok.data!.orderDetails.every((orderDetail) => (orderDetail.order.status == OrderStatus.PENDING &&
                  orderDetail.order.paymentMethod == PaymentTypes.Wallet))) {
                showDialogToAlert(
                  context,
                  title: Text('Bạn đã đặt thành công ${_multiOrderResp.count} đơn hàng'),
                  children: [
                    const Text('Vui lòng chờ xác nhận từ cửa hàng'),
                  ],
                ).then((_) => context.go(OrderPurchasePage.path));
              } else {
                showDialogToAlert(
                  context,
                  title: const Text('Đặt hàng không thành công từ ví VTV'),
                  children: [
                    const Text('Vui lòng xem chi tiết trong mục "Đơn hàng đang chờ"'),
                  ],
                ).then((_) => context.go(OrderPurchasePage.path));
              }
            }
          } else {
            //! COD
            showDialogToAlert(
              context,
              title: Text('Bạn đã đặt thành công ${_multiOrderResp.count} đơn hàng'),
              children: [
                const Text('Vui lòng chờ xác nhận từ cửa hàng'),
              ],
            ).then((_) => context.go(OrderPurchasePage.path));
          }
        },
      );
    }
  }

  Future<void> handleVNPay(SuccessResponse<MultipleOrderResp> ok) async {
    final String? uriPayment = await sl<OrderRepository>().createPaymentForMultiOrder(ok.data!.cardIds).then(
          (respEither) => respEither.fold((error) => null, (ok) => ok.data),
        );

    if (uriPayment != null && mounted) {
      await showDialogToAlert(
        context,
        title: const Text('Đặt hàng thành công', textAlign: TextAlign.center),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        children: [
          Text(
              'Các đơn hàng của bạn đã được đặt thành công với phương thức thanh toán ${_multipleOrderRequestParam.paymentMethod.name}\n'),
          const Text('Bạn sẽ được chuyển đến trang thanh toán'),
        ],
      );

      if (mounted) {
        await context.push(
          VNPayWebView.pathSingleOrder,
          extra: WebViewPaymentExtra(ok.data!.cardIds, uriPayment),
        );
      }
    } else if (uriPayment == null && mounted) {
      showDialogToAlert(
        context,
        title: const Text('Đặt hàng thành công (chưa thanh toán)', textAlign: TextAlign.center),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        confirmText: 'Xác nhận',
        children: [
          const Text('Các đơn hàng của bạn đã được đặt thành công'),
          const Text(
              'Trong quá trình thanh toán đã xảy ra lỗi, quý khách hãy vào mục "Đơn hàng đang chờ" để thanh toán lại'),
        ],
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
      bottomSheet: placeOrderBottomSheet(context),
      body: ListView(
        children: [
          _address(context),

          //# Multi-order
          for (var i = 0; i < widget.multiOrderResp.orderDetails.length; i++)
            Wrapper(
              margin: const EdgeInsets.only(top: 8),
              child: SingleOrderCheckoutView(
                param: _multipleOrderRequestParam.orderRequestWithCarts[i],
                orderDetail: _multiOrderResp.orderDetails[i],
                onOrderRequestChanged: (param) => handleChangedOrderRequestAtIndex(param, i),
                onUseLoyaltyPointChanged: (isUse) {
                  _multipleOrderRequestParam.setUseLoyaltyPoint(isUse, i); // update value
                  handleChangedOrderRequest(_multipleOrderRequestParam); // re-fetch data
                },
                onNoteChanged: (note) {
                  _multipleOrderRequestParam.changeNote(index: i, note: note); // local change
                },
                //? point > 0 && (index == i || index == null)
                showUseLoyaltyPoint: _multiOrderResp.orderDetails.first.totalPoint! > 0 &&
                    (_multipleOrderRequestParam.loyaltyPointIndex == i ||
                        _multipleOrderRequestParam.loyaltyPointIndex == null),
              ),
            ),
          const SizedBox(height: 8),

          //# payment method
          OrderSectionPaymentMethod(
            paymentMethod: _multipleOrderRequestParam.paymentMethod,
            onChanged: (method) {
              _multipleOrderRequestParam.paymentMethod = method;
              handleChangedOrderRequest(_multipleOrderRequestParam);
            },
            balance: _multiOrderResp.orderDetails.first.balance,
          ),
          const SizedBox(height: 4),

          //# system voucher code
          OrderSectionSystemVoucher(
            systemVoucherCode: _multipleOrderRequestParam.systemVoucherCode,
            onPressed: () async {
              final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
                builder: (context) {
                  return VoucherPage(
                    returnValue: true,
                    future: sl<VoucherRepository>().listOnSystem(),
                  );
                },
              ));

              if (voucher != null) {
                if (_multipleOrderRequestParam.systemVoucherCode != voucher.code) {
                  _multipleOrderRequestParam.systemVoucherCode = voucher.code;
                  handleChangedOrderRequest(_multipleOrderRequestParam);
                }
              }
            },
          ),
          const SizedBox(height: 4),

          //# checkout summary & place order button
          OrderSectionMultiOrderPayment(multiOrderResp: _multiOrderResp),
          const SizedBox(height: 56),
        ],
      ),
    );
  }

  Widget _address(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Address(
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

  BottomSheet placeOrderBottomSheet(BuildContext context) => BottomSheet(
        enableDrag: false,
        onClosing: () {},
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        builder: (context) => Container(
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Tổng thanh toán: '),
              Text(
                StringHelper.formatCurrency(_multiOrderResp.totalPayment),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: handlePlaceMultiOrder,
                child: const Text('Đặt hàng'),
              ),
            ],
          ),
        ),
      );
}
