import 'dart:developer';

import 'package:flutter/material.dart';

import '../components/address_summary.dart';
import 'add_address_page.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  static const routeName = 'address';
  static const route = '/home/cart/address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {
                      // TODO set default address
                    },
                  ),
                  Expanded(
                    child: AddressSummary(
                      onTap: () {
                        // TODO edit address
                      },
                      address: 'Hà Nội, Việt Nam',
                      receiver: 'Nguyễn Văn A',
                      phone: '8172468364',
                      icon: Icons.edit,
                    ),
                  ),
                ],
              );
            },
          ),
          TextButton(
            onPressed: () async {
              // GoRouter.of(context).go('/home/cart/address/add');
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddAddressPage();
                  },
                ),
              );

              log('result: $result');
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Thêm địa chỉ mới',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
