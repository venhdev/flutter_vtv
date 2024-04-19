import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/shop_info.dart';
import 'order_detail_page.dart';
import 'voucher_page.dart';

const String _noVoucherMsg = 'Chọn hoặc nhập mã';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.order, this.isCreateWithCart = true});

  static const String routeName = 'checkout';
  static const String path = '/home/cart/checkout';

  final OrderEntity order;

  // ?: check if this [OrderEntity] create with cart (in cart with cartId) or with product variant (buy now --not in cart)
  final bool isCreateWithCart;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late AddressEntity _address; // just ID
  late OrderEntity _order;
  // Properties sent to the server
  late PlaceOrderWithCartParam _placeOrderWithCartParam;
  late PlaceOrderWithVariantParam _placeOrderWithVariantParam;

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

  handlePlaceOrder() async {
    final isConfirmed = await showConfirmationDialog<bool>();

    if (isConfirmed ?? false) {
      final respEither = widget.isCreateWithCart
          ? await sl<OrderRepository>().placeOrderWithCart(_placeOrderWithCartParam)
          : await sl<OrderRepository>().placeOrderWithVariant(_placeOrderWithVariantParam);

      respEither.fold(
        (error) {
          // Fluttertoast.showToast(msg: 'Đặt hàng thất bại. Lỗi: ${error.message}');
          showDialogToAlert(
            context,
            title: const Text('Đặt hàng thất bại', textAlign: TextAlign.center),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
            children: [
              Text(error.message ?? 'Đã có lỗi xảy ra'),
            ],
          );
        },
        (ok) {
          // FetchCart to BLoC to update cart
          context.read<CartBloc>().add(const FetchCart()); //TODO this make show unwanted toast

          // navigate to order detail page
          context.go(OrderDetailPage.path, extra: ok.data);
        },
      );
    }
  }

  Future<T?> showDialogToChangeAddress<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogChooseAddress(
          onAddressChanged: (address) {
            if (widget.isCreateWithCart) {
              updateOrderWithCart(_placeOrderWithCartParam.copyWith(addressId: address.addressId), newAddress: address);
            } else {
              updateOrderWithVariant(_placeOrderWithVariantParam.copyWith(addressId: address.addressId),
                  newAddress: address);
            }
          },
        );
      },
    );
  }

  Future<void> updateOrderWithCart(PlaceOrderWithCartParam newOrderParam, {AddressEntity? newAddress}) async {
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
          _order = ok.data!.order;
        });
      },
    );
  }

  Future<void> updateOrderWithVariant(PlaceOrderWithVariantParam newOrderParam, {AddressEntity? newAddress}) async {
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
          _order = ok.data!.order;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _address = widget.order.address;
    _order = widget.order;

    if (widget.isCreateWithCart) {
      _placeOrderWithCartParam = PlaceOrderWithCartParam(
        addressId: widget.order.address.addressId,
        systemVoucherCode: null,
        shopVoucherCode: null,
        useLoyaltyPoint: false,
        paymentMethod: widget.order.paymentMethod,
        shippingMethod: widget.order.shippingMethod,
        note: '',
        cartIds: widget.order.orderItems.map((e) => e.cartId).toList(),
      );
    } else {
      _placeOrderWithVariantParam = PlaceOrderWithVariantParam(
        addressId: widget.order.address.addressId,
        systemVoucherCode: null,
        shopVoucherCode: null,
        useLoyaltyPoint: false,
        paymentMethod: widget.order.paymentMethod,
        shippingMethod: widget.order.shippingMethod,
        note: '',
        variantIds: widget.order.getVariantIdsAndQuantityMap,
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
      bottomSheet: _buildPlaceOrderBtn(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 64),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //! address
              _buildDeliveryAddress(context),
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

              //! voucher
              _buildSystemVoucherBtn(),
              const SizedBox(height: 8),

              //! loyalty point
              // _buildLoyaltyPoint(), //TODO implement this feature

              //! total price
              _buildTotalPrice(),
              const SizedBox(height: 8),

              //! note
              _buildNote(),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
        setState(() {
          if (widget.isCreateWithCart) {
            _placeOrderWithCartParam = _placeOrderWithCartParam.copyWith(note: value);
          } else {
            _placeOrderWithVariantParam = _placeOrderWithVariantParam.copyWith(note: value);
          }
        });
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

          if (widget.isCreateWithCart) ...[
            if (_placeOrderWithCartParam.systemVoucherCode != null)
              _totalSummaryPriceItem('Giảm giá hệ thống:', _order.discountSystem),
            if (_placeOrderWithCartParam.shopVoucherCode != null)
              _totalSummaryPriceItem('Giảm giá cửa hàng:', _order.discountShop),
          ] else ...[
            if (_placeOrderWithVariantParam.systemVoucherCode != null)
              _totalSummaryPriceItem('Giảm giá hệ thống:', _order.discountSystem),
            if (_placeOrderWithVariantParam.shopVoucherCode != null)
              _totalSummaryPriceItem('Giảm giá cửa hàng:', _order.discountShop),
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
      onTap: () => showDialogToChangeAddress(context),
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

  Widget _buildShopInfoAndItems() {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(
            shopId: _order.shop.shopId,
            name: _order.shop.name,
            avatar: _order.shop.avatar,
          ),

          //! Shop voucher
          Wrapper(
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
                  child: _buildShopVoucherBtn(),
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

  Widget _buildShopVoucherBtn() {
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
      },
      child: Text(
        widget.isCreateWithCart
            ? _placeOrderWithCartParam.shopVoucherCode ?? _noVoucherMsg
            : _placeOrderWithVariantParam.shopVoucherCode ?? _noVoucherMsg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: widget.isCreateWithCart
              ? _placeOrderWithCartParam.shopVoucherCode == null
                  ? Colors.grey
                  : Colors.green
              : _placeOrderWithVariantParam.shopVoucherCode == null
                  ? Colors.grey
                  : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSystemVoucherBtn() {
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
              widget.isCreateWithCart
                  ? _placeOrderWithCartParam.systemVoucherCode ?? _noVoucherMsg
                  : _placeOrderWithVariantParam.systemVoucherCode ?? _noVoucherMsg,
              style: TextStyle(
                color: widget.isCreateWithCart
                    ? _placeOrderWithCartParam.systemVoucherCode == null
                        ? Colors.grey
                        : Colors.green
                    : _placeOrderWithVariantParam.systemVoucherCode == null
                        ? Colors.grey
                        : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderBtn() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Tổng thanh toán: ',
          ),
          Text(
            StringHelper.formatCurrency(_order.paymentTotal),
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
