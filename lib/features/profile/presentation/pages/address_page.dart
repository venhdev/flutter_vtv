import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import 'add_address_page.dart';
import '../../domain/repository/profile_repository.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key, required this.willPopOnChanged});

  static const routeName = 'address';
  static const path = '/user/settings/address';

  /// pop the page when default address is changed
  final bool willPopOnChanged; 

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: sl<ProfileRepository>().getAllAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final respEither = snapshot.data!;
                      return respEither.fold(
                        (error) {
                          return MessageScreen.error(error.toString());
                        },
                        (ok) {
                          return _buildAddressList(ok.data!);
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            TextButton(
              onPressed: () async {
                // GoRouter.of(context).goNamed(AddAddressPage.routeName);
                final resultAddress = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddOrUpdateAddressPage(),
                  ),
                );

                if (resultAddress != null) {
                  setState(() {});
                }
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
      ),
    );
  }

  ListView _buildAddressList(List<AddressEntity> listAddress) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listAddress.length,
      itemBuilder: (context, index) {
        final address = listAddress[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Column(
                children: [
                  Radio(
                    value: address.status == "ACTIVE",
                    groupValue: true,
                    onChanged: (value) async {
                      final respEither = await sl<ProfileRepository>().updateAddressStatus(address.addressId);
                      respEither.fold(
                        (error) => Fluttertoast.showToast(msg: error.message!),
                        (ok) {
                          Fluttertoast.showToast(msg: ok.message!);
                          if (widget.willPopOnChanged) {
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),
                  if (address.status == "ACTIVE") const Text('Mặc\nđịnh', style: TextStyle(fontSize: 12)),
                ],
              ),
              Expanded(
                child: DeliveryAddress(
                  address: address,
                  suffixIcon: Icons.edit,
                  onTap: () async {
                    // final rs = await GoRouter.of(context).push<bool>(
                    //   AddOrUpdateAddressPage.pathUpdate,
                    //   extra: address,
                    // );

                    final rs = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddOrUpdateAddressPage(address: address);
                        },
                      ),
                    );

                    if (rs == true) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
