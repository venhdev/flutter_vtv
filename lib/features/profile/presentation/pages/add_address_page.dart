import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/profile_repository.dart';

/// This page will pop an [AddressEntity] when add success
class AddOrUpdateAddressPage extends StatefulWidget {
  const AddOrUpdateAddressPage({super.key, this.address});

  // static const routeNameAdd = 'add-address';
  // static const pathAdd = '/user/settings/address/add-address';

  // static const routeNameUpdate = 'update-address';
  // static const pathUpdate = '/user/settings/address/update-address';

  final AddressEntity? address;

  @override
  State<AddOrUpdateAddressPage> createState() => _AddOrUpdateAddressPageState();
}

class _AddOrUpdateAddressPageState extends State<AddOrUpdateAddressPage> {
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

  //update
  late int _addressId;

  bool isSaving = false; // for loading indicator when tapping 'Lưu địa chỉ'

  void _reset() {
    if (widget.address == null) {
      setState(() {
        _provinceName = null;
        _districtName = null;
        _wardName = null;
        _fullAddressController.clear();
        _phoneNumberController.clear();
        _receiverNameController.clear();
      });
    } else {
      setState(() {
        _provinceName = null;
        _districtName = null;
        _wardName = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _addressId = widget.address!.addressId;
      _provinceName = widget.address!.provinceName;
      _districtName = widget.address!.districtName;
      _wardName = widget.address!.wardName;

      _fullAddressController.text = widget.address!.fullAddress;
      _receiverNameController.text = widget.address!.fullName;
      _phoneNumberController.text = widget.address!.phone;

      _wardCode = widget.address!.wardCode;
    }
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
                        ? sl<GuestDataSource>().getProvinces()
                        : _districtName == null
                            ? sl<GuestDataSource>().getDistrictsByProvinceCode(_provinceCode!)
                            : sl<GuestDataSource>().getWardsByDistrictCode(_districtCode!),
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
            widget.address == null ? _buildAddAddressBtn(context) : _buildUpdateAddressBtn(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildAddAddressBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isSaving = true;
        });
        final respEither = await sl<ProfileRepository>().addAddress(
          AddOrUpdateAddressParam(
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
    );
  }

  ElevatedButton _buildUpdateAddressBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isSaving = true;
        });
        final respEither = await sl<ProfileRepository>().updateAddress(
          AddOrUpdateAddressParam(
            addressId: _addressId,
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
            Navigator.of(context)
                .pop<bool>(true); // true => flag to refresh address list on AddressPage (previous page)
          },
        );

        setState(() {
          isSaving = false;
        });
      },
      child: !isSaving
          ? const Text('Cập nhật địa chỉ')
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
