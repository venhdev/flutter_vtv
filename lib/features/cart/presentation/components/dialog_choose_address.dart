import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/profile/presentation/pages/add_address_page.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import 'address_summary.dart';

class DialogChooseAddress extends StatefulWidget {
  const DialogChooseAddress({
    super.key,
    required this.onAddressChanged,
  });

  final void Function(AddressEntity address) onAddressChanged;

  @override
  State<DialogChooseAddress> createState() => _DialogChooseAddressState();
}

class _DialogChooseAddressState extends State<DialogChooseAddress> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Địa chỉ nhận hàng', textAlign: TextAlign.center),
      content: FutureBuilder(
          future: sl<ProfileRepository>().getAllAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final respEither = snapshot.data!;
              return respEither.fold(
                (error) => const Text('Có lỗi xảy ra'),
                (ok) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    ok.data.length,
                    (index) => AddressSummary(
                      address: ok.data[index],
                      onTap: () {
                        widget.onAddressChanged(ok.data[index]);
                        Navigator.pop(context);
                      },
                      suffixIcon: null,
                      prefixIcon: null,
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      actions: [
        // close dialog
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Đóng'),
        ),
        // add new address
        TextButton(
          onPressed: () async {
            final newAddress = await Navigator.of(context).push<AddressEntity>(
              MaterialPageRoute(
                builder: (context) => const AddOrUpdateAddressPage(),
              ),
            );

            handleAddSuccess(newAddress);
          },
          child: const Text('Thêm địa chỉ mới'),
        ),
      ],
    );
  }

  void handleAddSuccess(AddressEntity? newAddress) {
    if (newAddress != null) {
      widget.onAddressChanged(newAddress);
      Navigator.pop(context);
    }
  }
}
// AddressSummary(
//             address: order.address,
//             onTap: () {
//               // change address
//             },
//             suffixIcon: null,
//             prefixIcon: null,
//           ),