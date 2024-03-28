import 'package:flutter/material.dart';

import '../../../profile/domain/entities/address_dto.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../components/address_summary.dart';
import '../components/cart_item.dart';
import '../components/order_item.dart';
import '../components/dialog_choose_address.dart';

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
  // Properties sent to the server
  late AddressEntity _address; // just ID

  Future<T?> showDialogToChangeAddress<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogChooseAddress(
          order: widget.order,
          onAddressChanged: (address) {
            setState(() {
              _address = address;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _address = widget.order.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //! address
            AddressSummary(
              address: _address,
              onTap: () => showDialogToChangeAddress(context),
            ),

            const SizedBox(height: 8),

            //! order summary
            //- shopInfo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // shop info --circle shop avatar
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.order.shop.avatar),
                      ),
                      const SizedBox(width: 4),
                      Text(widget.order.shop.name),
                    ],
                  ),

                  Divider(),

                  // list of items
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.order.orderItems[index];
                      return OrderItem(item);
                    },
                  ),
                ],
              ),
            ),

            //- items
            //! shipping method

            //! payment method

            //! voucher

            //! note
          ],
        ),
      ),
    );
  }
}

