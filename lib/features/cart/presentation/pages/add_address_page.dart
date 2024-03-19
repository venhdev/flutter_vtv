import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String? _province;
  String? _district;
  String? _ward;

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
      body: Column(
        children: [
         if (_province != null) Text(_province!),
          if (_district != null) Text(_district!),
          if (_ward != null) Text(_ward!),
          const Center(
            child: Text('AddAddressPage'),
          ),
        ],
      ),
    );
  }
}
