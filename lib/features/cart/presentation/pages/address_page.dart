import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../service_locator.dart';
import '../../data/data_sources/cart_data_source.dart';
import '../components/address_summary.dart';
import 'add_address_page.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  static const routeName = 'address';
  static const pathName = 'address';
  static const path = '/home/cart/address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: sl<CartDataSource>().getAllAddress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listAddress = snapshot.data!.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listAddress.length,
                    itemBuilder: (context, index) {
                      final address = listAddress[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: address.status == "ACTIVE",
                            onChanged: (value) {
                              // TODO set default address
                            },
                          ),
                          Expanded(
                            child: AddressSummary(
                              onTap: () {
                                // TODO edit address
                              },
                              address:
                                  '${address.fullAddress!}, ${address.wardFullName!}, ${address.districtFullName!}, ${address.provinceFullName!}',
                              receiver: address.fullName!,
                              phone: address.phone!,
                              icon: Icons.edit,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          TextButton(
            onPressed: () async {
              GoRouter.of(context).goNamed(AddAddressPage.routeName);
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
