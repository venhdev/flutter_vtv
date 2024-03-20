import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../service_locator.dart';
import '../../data/data_sources/cart_data_source.dart';
import '../../domain/dto/add_address_param.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  static const routeName = 'add_address';
  static const path = '/home/cart/address/add';
  static const pathName = 'add';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Thêm địa chỉ'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop('address');
            },
            icon: const Icon(Icons.arrow_back),
          )),
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
            _wardName == null
                ? Expanded(
                    child: FutureBuilder<dynamic>(
                        future: _provinceName == null
                            ? sl<CartDataSource>().getProvinces()
                            : _districtName == null
                                ? sl<CartDataSource>().getDistrictsByProvinceCode(_provinceCode!)
                                : sl<CartDataSource>().getWardsByDistrictCode(_districtCode!),
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
                : const SizedBox.shrink(),
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

            // btn 'Thiết lập lại' & 'Lưu địa chỉ'
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _provinceName = null;
                      _districtName = null;
                      _wardName = null;
                    });
                  },
                  child: const Text('Thiết lập lại'),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop('address');
                    try {
                      sl<CartDataSource>()
                          .addAddress(
                            AddAddressParam(
                              provinceName: _provinceName,
                              districtName: _districtName,
                              wardName: _wardName,
                              fullAddress: _fullAddressController.text,
                              fullName: _receiverNameController.text,
                              phone: _phoneNumberController.text,
                              wardCode: _wardCode,
                            ),
                          )
                          .then((resp) => Fluttertoast.showToast(msg: resp.message!));

                      // pop
                      Navigator.of(context).pop();
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }

                    Navigator.of(context).pop('address');
                  },
                  child: const Text('Lưu địa chỉ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
