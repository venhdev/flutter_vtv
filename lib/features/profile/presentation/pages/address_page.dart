import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/presentation/components/custom_widgets.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/components/address_summary.dart';
import 'add_address_page.dart';
import '../../domain/entities/address_dto.dart';
import '../../domain/repository/profile_repository.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  static const routeName = 'address';
  static const path = '/user/settings/address';

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
                          return _buildAddressList(ok.data);
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
                    builder: (context) => const AddAddressPage(),
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
              // Checkbox(
              //   value: address.status == "ACTIVE",
              //   onChanged: (value) async {
              //     final respEither = await sl<ProfileRepository>().updateAddressStatus(address.addressId!);
              //     respEither.fold(
              //       (error) => Fluttertoast.showToast(msg: error.message!),
              //       (ok) {
              //         Fluttertoast.showToast(msg: ok.message!);
              //         setState(() {});
              //       },
              //     );
              //   },
              // ),
              Radio(
                value: address.status == "ACTIVE",
                groupValue: true,
                onChanged: (value) async {
                  final respEither = await sl<ProfileRepository>().updateAddressStatus(address.addressId);
                  respEither.fold(
                    (error) => Fluttertoast.showToast(msg: error.message!),
                    (ok) {
                      Fluttertoast.showToast(msg: ok.message!);
                      // setState(() {});
                      Navigator.of(context).pop(true);
                    },
                  );
                },
              ),
              Expanded(
                child: AddressSummary(
                  address: address,
                  suffixIcon: Icons.edit,
                  onTap: () {
                    // TODO edit address
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
