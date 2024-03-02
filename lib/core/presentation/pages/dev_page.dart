import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/shared_preferences_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../service_locator.dart';
import '../../constants/api.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  static const String routeName = '/dev';

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  Future<void> setDomain(String newDomain) async {
    if (newDomain == devDOMAIN) {
      Fluttertoast.showToast(msg: 'Domain is the same');
    } else {
      devDOMAIN = newDomain;
      await sl<SharedPreferencesHelper>().I.setString('devDomain', devDOMAIN);
      Fluttertoast.showToast(msg: 'Server domain has been changed to $devDOMAIN');
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
                  onPressed: () async {
                    await setDomain(domainTextController.text);
                  },
                  icon: const Icon(Icons.save),
                ),
              ),
              // init value
              controller: domainTextController,
              // save button
              onSubmitted: (value) async {
                await setDomain(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
