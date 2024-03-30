import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart';
import 'package:flutter_vtv/core/helpers/shared_preferences_helper.dart';
import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../service_locator.dart';
import '../../constants/api.dart';
import '../components/custom_buttons.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  static const String routeName = '/dev';

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  String accessToken = '';
  String? fcmToken = '';
  String? newAccessToken;

  TextEditingController domainTextController = TextEditingController(text: devDOMAIN);
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

  @override
  void initState() {
    super.initState();
    domainTextController.text = devDOMAIN;
    sl<SecureStorageHelper>().accessToken.then((token) {
      if (mounted && token != null) {
        Fluttertoast.showToast(msg: 'loaded access token');
        setState(() {
          accessToken = token;
        });
      }
    });

    fcmToken = sl<FirebaseCloudMessagingManager>().currentFCMToken;
  }

  @override
  void dispose() {
    domainTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Dev Page - Tap to copy'),
          leading: IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: const Icon(Icons.arrow_back),
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildDomain(),
            const Divider(),
            _buildToken(),
            const Divider(),
            _buildFCM(),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TestPage(),
                  ),
                );
              },
              child: const Text('Button'),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildFCM() {
    return Column(
      children: [
        // current FCM token
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: fcmToken ?? 'null'));
            Fluttertoast.showToast(msg: 'Copied to clipboard FCM token');
          },
          child: Text('FCM token: $fcmToken'),
        ),
      ],
    );
  }

  Widget _buildToken() {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: accessToken));
            Fluttertoast.showToast(msg: 'Copied to clipboard access token');
          },
          child: Text('accessToken: $accessToken'),
        ),
        ElevatedButton(
          onPressed: () async {
            final accessToken = await sl<SecureStorageHelper>().accessToken;
            if (mounted && accessToken != null) {
              setState(() {
                Fluttertoast.showToast(msg: 'get current access token success');
                this.accessToken = accessToken;
              });
            }
          },
          child: const Text('Get current access token'),
        ),

        // call usecase to get new access token
        if (newAccessToken != null)
          GestureDetector(
            child: Text('newAccessToken: $newAccessToken'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: newAccessToken ?? ''));
              Fluttertoast.showToast(msg: 'Copied to clipboard new access token');
            },
          ),
        ElevatedButton(
          onPressed: () async {
            // final result = await sl<CheckTokenUC>().call(accessToken);
            await sl<AuthCubit>().onStarted();
            // Fluttertoast.showToast(msg: 'result: $result');
            final currentToken = getCurrentToken();
            if (mounted && currentToken != null) {
              setState(() {
                newAccessToken = currentToken;
              });
            }
            if (newAccessToken == currentToken) {
              Fluttertoast.showToast(msg: 'SAME TOKEN');
            }
          },
          child: const Text('Check and get new access token'),
        ),
      ],
    );
  }

  Column _buildDomain() {
    return Column(
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
    );
  }

  String? getCurrentToken() {
    return context.read<AuthCubit>().state.auth?.accessToken;
  }
}

class TestPage extends StatelessWidget {
  const TestPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------------------------
              Container(
                // color: Colors.blue,
                child: IconTextButton(
                  onPressed: () {},
                  icon: Icons.chat,
                  label: 'Chat',
                  borderRadius: BorderRadius.zero,
                  backgroundColor: Colors.blue,
                ),
              ),

              Container(
                color: Colors.red,
                child: TextButton(
                  onPressed: () {
                    context.go('/dev');
                  },
                  child: const Text('Go to dev page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
