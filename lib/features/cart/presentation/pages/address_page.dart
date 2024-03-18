import 'package:flutter/material.dart';

import '../components/address_summary.dart';

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
      body: ListView.builder(
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
    );
  }
}
