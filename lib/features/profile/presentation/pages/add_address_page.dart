import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../data/data_sources/profile_data_source.dart';
import '../../domain/repository/profile_repository.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  static const routeName = 'add-address';
  static const path = '/user/settings/address/add-address';

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  // text controllers
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  String? _provinceName;
  String? _provinceCode;
  String? _districtName;
  String? _districtCode;
  String? _wardName;
  String? _wardCode;

  bool isSaving = false; // for loading indicator when tapping 'Lưu địa chỉ'

  void _reset() {
    setState(() {
      _provinceName = null;
      _districtName = null;
      _wardName = null;
      _fullAddressController.clear();
      _phoneNumberController.clear();
      _receiverNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm địa chỉ'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // reset button
          TextButton(
            onPressed: () {
              setState(() {
                _reset();
              });
            },
            child: const Text('Thiết lập lại'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _provinceName != null ? Text('Tỉnh/thành phố: ${_provinceName!}') : const Text('Chọn tỉnh/thành phố'),
            _districtName != null
                ? Text('Quận/huyện: $_districtName')
                : _provinceName == null
                    ? const SizedBox.shrink()
                    : const Text('Chọn quận/huyện'),
            _wardName != null
                ? Text('Phường/xã: $_wardName')
                : _districtName == null
                    ? const SizedBox.shrink()
                    : const Text('Chọn phường/xã'),
            if (_wardName == null)
              Expanded(
                child: FutureBuilder<dynamic>(
                    future: _provinceName == null
                        ? sl<ProfileDataSource>().getProvinces()
                        : _districtName == null
                            ? sl<ProfileDataSource>().getDistrictsByProvinceCode(_provinceCode!)
                            : sl<ProfileDataSource>().getWardsByDistrictCode(_districtCode!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            final obj = snapshot.data!.data[index];
                            return ListTile(
                              title: Text(obj.name),
                              onTap: () {
                                setState(() {
                                  if (_provinceName == null) {
                                    _provinceName = obj.name;
                                    _provinceCode = obj.provinceCode;
                                  } else if (_districtName == null) {
                                    _districtName = obj.name;
                                    _districtCode = obj.districtCode;
                                  } else {
                                    _wardName = obj.name;
                                    _wardCode = obj.wardCode;
                                  }
                                });
                              },
                            );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )
            else
              const SizedBox.shrink(),
            // Full address text field
            if (_wardName != null) ...[
              // Full address text field
              TextField(
                controller: _fullAddressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ cụ thể',
                  hintText: 'Nhập địa chỉ cụ thể',
                ),
              ),
              // Phone number text field
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại',
                ),
              ),
              // Receiver name text field
              TextField(
                controller: _receiverNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người nhận',
                  hintText: 'Nhập tên người nhận',
                ),
              ),
            ],
            // save button
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isSaving = true;
                });
                final respEither = await sl<ProfileRepository>().addAddress(
                  AddAddressParam(
                    provinceName: _provinceName,
                    districtName: _districtName,
                    wardName: _wardName,
                    fullAddress: _fullAddressController.text,
                    fullName: _receiverNameController.text,
                    phone: _phoneNumberController.text,
                    wardCode: _wardCode,
                  ),
                );

                respEither.fold(
                  (error) {
                    Fluttertoast.showToast(msg: error.message!);
                  },
                  (ok) {
                    Fluttertoast.showToast(msg: ok.message!);
                    // pop this page
                    Navigator.of(context).pop<AddressEntity>(ok.data);
                  },
                );

                setState(() {
                  isSaving = false;
                });
              },
              child: !isSaving
                  ? const Text('Lưu địa chỉ')
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
