import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/api.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  static const String routeName = '/dev';

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  void setDomain(String newDomain) {
    if (newDomain == devDOMAIN) {
      Fluttertoast.showToast(msg: 'Domain is the same');
    } else {
      devDOMAIN = newDomain;
      setState(() {});
    }
  }

  TextEditingController domainTextController = TextEditingController(text: devDOMAIN);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('current Domain: $devDOMAIN'),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Domain',
                suffixIcon: IconButton(
                  onPressed: () {
                    setDomain(domainTextController.text);
                  },
                  icon: const Icon(Icons.save),
                ),
              ),
              // init value
              controller: domainTextController,
              // save button
              onSubmitted: (value) {
                setDomain(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
