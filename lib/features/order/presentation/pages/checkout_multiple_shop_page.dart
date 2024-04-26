import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/order/domain/dto/multiple_order_request_param.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';
import 'package:vtv_common/shop.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import 'voucher_page.dart';

const String _noVoucherMsg = 'Chọn hoặc nhập mã';

// @override
//   void initState() {
//     super.initState();
//     _address = widget.orderDetail.order.address;
//     _order = widget.orderDetail.order;
//     // REVIEW
//     _placeOrderWithCartParam = OrderRequestWithCartParam(
//       addressId: widget.orderDetail.order.address.addressId,
//       systemVoucherCode: null,
//       shopVoucherCode: null,
//       useLoyaltyPoint: true,
//       paymentMethod: widget.orderDetail.order.paymentMethod,
//       shippingMethod: widget.orderDetail.order.shippingMethod,
//       note: '',
//       cartIds: widget.orderDetail.order.orderItems.map((e) => e.cartId).toList(),
//     );
//   }

class CheckoutMultipleShopPage extends StatefulWidget {
  const CheckoutMultipleShopPage({
    super.key,
    required this.orderDetails,
  });

  static const String routeName = 'multi-checkout';
  static const String path = '/home/cart/multi-checkout';

  final MultiOrderDetail orderDetails;

  @override
  State<CheckoutMultipleShopPage> createState() => _CheckoutMultipleShopPageState();
}

class _CheckoutMultipleShopPageState extends State<CheckoutMultipleShopPage> {
  late MultipleOrderRequestParam _multipleOrderRequestParam;
  late MultiOrderDetail _orderDetails;

  Future<void> handleChangedOrderRequest(OrderRequestWithCartParam param, int index) async {
    final tempParam = _multipleOrderRequestParam.copyWithIndex(param: param, index: index);
    final respEither = await sl<OrderRepository>().createMultiOrderByRequest(tempParam);

    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Đã xảy ra lỗi khi tạo đơn hàng');
      },
      (ok) {
        setState(() {
          _multipleOrderRequestParam = tempParam;
          _orderDetails = ok.data!;
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
    _multipleOrderRequestParam = MultipleOrderRequestParam.fromOrderDetails(widget.orderDetails);
    _orderDetails = widget.orderDetails;
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
            child: ListView.builder(
              itemCount: widget.orderDetails.length,
              itemBuilder: (context, index) => SingleCheckoutView(
                orderDetail: _orderDetails[index],
                onOrderRequestChanged: (param) {
                  handleChangedOrderRequest(param, index);
                  // setState(() {
                  //   _multipleOrderRequestParam.orderRequestWithCarts[index] = param;
                  // });
                },
                param: _multipleOrderRequestParam.orderRequestWithCarts[index],
              ),
            ),
          ),
          _buildPlaceOrderBottomSheet(context)
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBottomSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Tổng thanh toán: '),
          Text(
            StringHelper.formatCurrency(
                _orderDetails.fold(0, (acc, orderDetail) => acc + orderDetail.order.paymentTotal)), //acc: accumulator
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
      ),
    );
  }
}

class SingleCheckoutView extends StatelessWidget {
  SingleCheckoutView({
    super.key,
    required this.orderDetail,
    required this.onOrderRequestChanged,
    required OrderRequestWithCartParam param,
  })  : _placeOrderWithCartParam = param,
        _order = orderDetail.order,
        _address = orderDetail.order.address;

  final OrderDetailEntity orderDetail;
  final void Function(OrderRequestWithCartParam param) onOrderRequestChanged;

  final OrderRequestWithCartParam _placeOrderWithCartParam;
  final OrderEntity _order;
  final AddressEntity _address;

  @override
  Widget build(BuildContext context) {
    // appBar: AppBar(
    //     title: const Text('Thanh toán'),
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back),
    //       onPressed: () => context.pop(),
    //     )),
    // bottomSheet: _buildPlaceOrderBottomSheet(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          //! address
          _buildDeliveryAddress(context),
          const SizedBox(height: 8),

          //! order summary
          _buildShopInfoAndItems(context), // shop info, list of items
          const SizedBox(height: 8),

          //! shipping method
          _buildShippingMethod(),
          const SizedBox(height: 8),

          //! payment method
          _buildPaymentMethod(),
          const SizedBox(height: 8),

          //! voucher
          _buildSystemVoucherBtn(context),
          const SizedBox(height: 8),

          //! loyalty point
          _buildLoyaltyPoint(),
          const SizedBox(height: 8),

          //! total price
          _buildTotalPrice(),
          const SizedBox(height: 8),

          //! note
          _buildNote(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLoyaltyPoint() {
    return Wrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sử dụng điểm tích lũy', style: TextStyle(fontWeight: FontWeight.bold)),
              FutureBuilder(
                  future: sl<ProfileRepository>().getLoyaltyPoint(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.fold(
                        (error) => const SizedBox.shrink(),
                        (ok) => Text(
                          'Điểm hiện có: ${ok.data!.totalPoint}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
            ],
          ),
          Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: _placeOrderWithCartParam.useLoyaltyPoint,
            onChanged: (value) {
              onOrderRequestChanged(
                _placeOrderWithCartParam.copyWith(useLoyaltyPoint: value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return TextField(
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
        hintText: 'Ghi chú',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onChanged: (value) {
        //TODO note changed

        // _placeOrderWithCartParam = _placeOrderWithCartParam.copyWith(note: value);
      },
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
          _totalSummaryPriceItem('Tổng tiền hàng:', _order.totalPrice),
          _totalSummaryPriceItem('Phí vận chuyển:', _order.shippingFee),

          if (_placeOrderWithCartParam.systemVoucherCode != null)
            _totalSummaryPriceItem('Giảm giá hệ thống:', _order.discountSystem),
          if (_placeOrderWithCartParam.shopVoucherCode != null)
            _totalSummaryPriceItem('Giảm giá cửa hàng:', _order.discountShop),

          //? not null means using loyalty point
          if (_order.loyaltyPointHistory != null) ...[
            //? maybe negative point >> no need to add '-' sign
            _totalSummaryPriceItem('Sử dụng điểm tích lũy:', _order.loyaltyPointHistory!.point),
          ],

          // total price
          const Divider(thickness: 0.2, height: 4),
          _totalSummaryPriceItem('Tổng thanh toán:', _order.paymentTotal),
        ],
      ),
    );
  }

  Widget _totalSummaryPriceItem(String title, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(StringHelper.formatCurrency(price)),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Phương thức thanh toán',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Widget _buildDeliveryAddress(BuildContext context) {
    return AddressSummary(
      address: _address,
      onTap: () => showDialogToChangeAddress(context, (address) {
        onOrderRequestChanged(
          _placeOrderWithCartParam.copyWith(addressId: address.addressId),
        );
      }),
    );
  }

  Widget _buildShippingMethod() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Phương thức vận chuyển',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // method name
              Text(_order.shippingMethod),

              // shipping fee
              Text(
                'Phí vận chuyển: ${_order.shippingFee}',
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems(BuildContext context) {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(
            shopId: _order.shop.shopId,
            shopName: _order.shop.name,
            shopAvatar: _order.shop.avatar,
            hideAllButton: true,
          ),

          //! Shop voucher
          Wrapper(
            useBoxShadow: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Mã giảm giá cửa hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildShopVoucherBtn(context),
                ),
              ],
            ),
          ),
          // const Divider(thickness: 0.4, height: 8),
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
          onOrderRequestChanged(
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

  Widget _buildSystemVoucherBtn(BuildContext context) {
    return InkWell(
      onTap: () async {
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

        if (voucher != null) {
          onOrderRequestChanged(
            _placeOrderWithCartParam.copyWith(systemVoucherCode: voucher.code),
          );
        }
      },
      overlayColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.2)),
      child: Wrapper(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mã giảm giá',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _placeOrderWithCartParam.systemVoucherCode ?? _noVoucherMsg,
              style: TextStyle(
                color: _placeOrderWithCartParam.systemVoucherCode == null ? Colors.grey : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
