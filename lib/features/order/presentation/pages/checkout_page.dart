import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../service_locator.dart';
import '../../../profile/domain/entities/address_dto.dart';
import 'voucher_page.dart';
import '../../domain/dto/place_order_param.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../../domain/repository/voucher_repository.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/dialog_choose_address.dart';
import '../../../cart/presentation/components/order_item.dart';

const String noVoucherMsg = 'Chọn hoặc nhập mã';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.order,
  });

  static const String routeName = 'checkout';
  static const String path = '/home/cart/checkout';

  final OrderEntity order;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
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

    // _systemVoucherCode = widget.order.voucherOrders
    //     .firstWhere(
    //       (voucher) => !voucher.type!,
    //       orElse: () => VoucherOrderEntity.empty(),
    //     )
    //     .voucherName;

    // _shopVoucherCode = widget.order.voucherOrders
    //     .firstWhere(
    //       (voucher) => voucher.type!,
    //       orElse: () => VoucherOrderEntity.empty(),
    //     )
    //     .voucherName;

    // _paymentMethod = widget.order.paymentMethod;
    // _shippingMethod = widget.order.shippingMethod;
    // _cartIds = widget.order.orderItems.map((e) => e.cartId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
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

  TextField _buildNote() {
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
          _placeOrderParam = _placeOrderParam.copyWith(note: value);
        });
      },
    );
  }

  Wrapper _buildTotalPrice() {
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
          _totalSummaryPriceItem('Tổng thanh toán:', _order.paymentTotal),
        ],
      ),
    );
  }

  Row _totalSummaryPriceItem(String title, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(formatCurrency(price)),
      ],
    );
  }

  Wrapper _buildPaymentMethod() {
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
              Text(formatPaymentMethod(_order.paymentMethod)),
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_order.shop.avatar),
                ),
                const SizedBox(width: 4),
                Text(_order.shop.name),
              ],
            ),
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
          const Divider(thickness: 0.4, height: 8),

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

  GestureDetector _buildShopVoucherBtn() {
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
          reloadOrder(
            _placeOrderParam.copyWith(shopVoucherCode: voucher.code),
          );
        }
      },
      child: Text(
        _placeOrderParam.shopVoucherCode ?? noVoucherMsg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: _placeOrderParam.shopVoucherCode == null ? Colors.grey : Colors.green,
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
          reloadOrder(
            _placeOrderParam.copyWith(systemVoucherCode: voucher.code),
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
              _placeOrderParam.systemVoucherCode ?? noVoucherMsg,
              style: TextStyle(
                color: _placeOrderParam.systemVoucherCode == null ? Colors.grey : Colors.green,
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
            formatCurrency(_order.paymentTotal),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () async {
              final respEither = await sl<OrderRepository>().placeOrder(_placeOrderParam);

              respEither.fold(
                (error) {
                  Fluttertoast.showToast(msg: 'Đặt hàng thất bại. Lỗi: ${error.message}');
                },
                (ok) {
                  Fluttertoast.showToast(msg: ok.message ?? 'Đặt hàng thành công');
                  sl<CartBloc>().add(const FetchCart());
                },
              );
            },
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
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
