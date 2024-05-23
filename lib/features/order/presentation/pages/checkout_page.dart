import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/order/presentation/pages/customer_order_detail_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/dialog_to_confirm_checkout.dart';
import 'voucher_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.orderDetail, this.isCreateWithCart = true});

  static const String routeName = 'checkout';
  static const String path = '/home/cart/checkout';

  final OrderDetailEntity orderDetail;

  //? check if this [OrderEntity]
  //- create with cart (in cart with cartId) or
  //- with product variant (buy now --not in cart)
  final bool isCreateWithCart;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late AddressEntity _address; // just ID
  late OrderDetailEntity _orderDetail;
  // Properties sent to the server
  late OrderRequestWithCartParam _placeOrderWithCartParam;
  late OrderRequestWithVariantParam _placeOrderWithVariantParam;

  Future<T?> showDialogToChangeAddress<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogChooseAddress(
          onAddressChanged: (address) {
            if (widget.isCreateWithCart) {
              updateOrderWithCart(
                _placeOrderWithCartParam.copyWith(addressId: address.addressId),
                newAddress: address,
              );
            } else {
              updateOrderWithVariant(
                _placeOrderWithVariantParam.copyWith(addressId: address.addressId),
                newAddress: address,
              );
            }
          },
        );
      },
    );
  }

  Future<void> updateOrderWithCart(OrderRequestWithCartParam newOrderParam, {AddressEntity? newAddress}) async {
    final respEither = await sl<OrderRepository>().createUpdateWithCart(newOrderParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: 'Lỗi: ${error.message}');
      },
      (ok) {
        setState(() {
          _placeOrderWithCartParam = newOrderParam;
          if (newAddress != null) {
            _address = newAddress;
          }
          _orderDetail = ok.data!;
        });
      },
    );
  }

  Future<void> updateOrderWithVariant(OrderRequestWithVariantParam newOrderParam, {AddressEntity? newAddress}) async {
    final respEither = await sl<OrderRepository>().createUpdateWithVariant(newOrderParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: 'Lỗi: ${error.message}');
      },
      (ok) {
        setState(() {
          _placeOrderWithVariantParam = newOrderParam;
          if (newAddress != null) {
            _address = newAddress;
          }
          _orderDetail = ok.data!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _address = widget.orderDetail.order.address;
    _orderDetail = widget.orderDetail;

    if (widget.isCreateWithCart) {
      _placeOrderWithCartParam = OrderRequestWithCartParam(
        addressId: widget.orderDetail.order.address.addressId,
        systemVoucherCode: null,
        shopVoucherCode: null,
        useLoyaltyPoint: false,
        paymentMethod: widget.orderDetail.order.paymentMethod,
        shippingMethod: widget.orderDetail.order.shippingMethod,
        note: '',
        cartIds: widget.orderDetail.order.orderItems.map((e) => e.cartId).toList(),
      );
    } else {
      _placeOrderWithVariantParam = OrderRequestWithVariantParam(
        addressId: widget.orderDetail.order.address.addressId,
        systemVoucherCode: null,
        shopVoucherCode: null,
        useLoyaltyPoint: false,
        paymentMethod: widget.orderDetail.order.paymentMethod,
        shippingMethod: widget.orderDetail.order.shippingMethod,
        note: '',
        variantIds: widget.orderDetail.order.getVariantIdsAndQuantityMap,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Thanh toán'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          )),
      bottomSheet: _buildPlaceOrderBottomSheet(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 64),
        child: ListView(
          children: [
            //# address
            Address(
              address: _address,
              onTap: () => showDialogToChangeAddress(context),
            ),
            const SizedBox(height: 8),

            //# shop info, list of items, shop voucher picker
            OrderSectionShopItems(
              order: _orderDetail.order,
              shopVoucherCode: widget.isCreateWithCart
                  ? _placeOrderWithCartParam.shopVoucherCode
                  : _placeOrderWithVariantParam.shopVoucherCode,
              onShopVoucherPressed: () async {
                // show dialog to choose voucher
                await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
                  builder: (context) {
                    return VoucherPage(
                      returnValue: true,
                      title: 'Voucher của ${_orderDetail.order.shop.name}',
                      future: sl<VoucherRepository>().listOnShop(_orderDetail.order.shop.shopId),
                    );
                  },
                )).then((voucher) {
                  if (voucher != null) {
                    if (widget.isCreateWithCart) {
                      updateOrderWithCart(
                        _placeOrderWithCartParam.copyWith(shopVoucherCode: voucher.code),
                      );
                    } else {
                      updateOrderWithVariant(
                        _placeOrderWithVariantParam.copyWith(shopVoucherCode: voucher.code),
                      );
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 8),

            //# shipping method
            OrderSectionShippingMethod(order: _orderDetail.order),
            const SizedBox(height: 8),

            //# payment method
            OrderSectionPaymentMethod(
                paymentMethod: widget.isCreateWithCart
                    ? _placeOrderWithCartParam.paymentMethod
                    : _placeOrderWithVariantParam.paymentMethod,
                balance: widget.orderDetail.balance,
                onChanged: (value) {
                  if (widget.isCreateWithCart) {
                    updateOrderWithCart(
                      _placeOrderWithCartParam.copyWith(paymentMethod: value),
                    );
                  } else {
                    updateOrderWithVariant(
                      _placeOrderWithVariantParam.copyWith(paymentMethod: value),
                    );
                  }
                }),

            const SizedBox(height: 8),

            //# sys voucher
            OrderSectionSystemVoucher(
              systemVoucherCode: widget.isCreateWithCart
                  ? _placeOrderWithCartParam.systemVoucherCode
                  : _placeOrderWithVariantParam.systemVoucherCode,
              onPressed: () async {
                // show dialog to choose voucher
                final voucher = await Navigator.of(context).push<VoucherEntity>(MaterialPageRoute(
                  builder: (context) {
                    return VoucherPage(
                      title: 'Voucher của bạn',
                      returnValue: true,
                      future: sl<VoucherRepository>().customerVoucherList(),
                      canFindMore: true,
                    );
                  },
                ));

                if (voucher != null) {
                  if (widget.isCreateWithCart) {
                    updateOrderWithCart(
                      _placeOrderWithCartParam.copyWith(systemVoucherCode: voucher.code),
                    );
                  } else {
                    updateOrderWithVariant(
                      _placeOrderWithVariantParam.copyWith(systemVoucherCode: voucher.code),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 8),

            //! loyalty point
            // _buildLoyaltyPoint(),
            OrderSectionLoyaltyPoint(
                totalPoint: _orderDetail.totalPoint!,
                isUsingLoyaltyPoint: widget.isCreateWithCart
                    ? _placeOrderWithCartParam.useLoyaltyPoint
                    : _placeOrderWithVariantParam.useLoyaltyPoint,
                onChanged: (value) {
                  log('value: $value');
                  if (widget.isCreateWithCart) {
                    updateOrderWithCart(
                      _placeOrderWithCartParam.copyWith(useLoyaltyPoint: value),
                    );
                  } else {
                    updateOrderWithVariant(
                      _placeOrderWithVariantParam.copyWith(useLoyaltyPoint: value),
                    );
                  }
                }),
            const SizedBox(height: 8),

            //! total price
            // _singleOrderTotalPrice(),
            OrderSectionSingleOrderPayment(order: _orderDetail.order),
            const SizedBox(height: 8),

            //! note
            // _buildNote(),
            OrderSectionNote(
              note: widget.isCreateWithCart ? _placeOrderWithCartParam.note : _placeOrderWithVariantParam.note,
              onChanged: (value) {
                if (widget.isCreateWithCart) {
                  _placeOrderWithCartParam = _placeOrderWithCartParam.copyWith(note: value);
                } else {
                  _placeOrderWithVariantParam = _placeOrderWithVariantParam.copyWith(note: value);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderBottomSheet() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Tổng thanh toán: '),
          Text(
            ConversionUtils.formatCurrency(_orderDetail.order.paymentTotal),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () async {
              final isConfirmed = await showDialogToConfirmCheckout<bool>(context);

              if (isConfirmed ?? false) {
                final respEither = widget.isCreateWithCart
                    ? await sl<OrderRepository>().placeOrderWithCart(_placeOrderWithCartParam)
                    : await sl<OrderRepository>().placeOrderWithVariant(_placeOrderWithVariantParam);

                respEither.fold(
                  (error) {
                    showDialogToAlert(
                      context,
                      title: const Text('Đặt hàng thất bại', textAlign: TextAlign.center),
                      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                      children: [
                        Text(error.message ?? 'Đã có lỗi xảy ra khi đặt hàng, vui lòng thử lại sau.'),
                      ],
                    );
                  },
                  (ok) async {
                    //! Online payment
                    if (ok.data!.order.status == OrderStatus.UNPAID) {
                      // get uri payment
                      await CustomerHandler.processSingleOrderPaymentByVNPay(context, ok.data!.order.orderId!);
                    } else {
                      //! COD
                      // FetchCart to BLoC to update cart
                      context.read<CartBloc>().add(const FetchCart()); //OK_TODO this make show unwanted toast
                      // navigate to order detail page
                      context.go(CustomerOrderDetailPage.path, extra: ok.data);
                    }
                  },
                );
              }
            },
            child: const Text('Đặt hàng'),
          ),
        ],
      ),
    );
  }
}
