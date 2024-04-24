import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../config/dio/auth_interceptor.dart';
import '../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../service_locator.dart';
import '../../constants/customer_api.dart';

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

  String? forceAccessToken;

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
      appBar: _devAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRoles(),
            _buildDomain(),
            const Divider(),
            _buildToken(),
            const Divider(),
            _buildFCM(),
            const Divider(),
            // textfield to force replace accessToken
            _buildForceChangeAccessToken(),

            //*--------------------------------
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const TestPage(),
            //       ),
            //     );
            //   },
            //   child: const Text('Button'),
            // ),

            _goToTestPage(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _goToTestPage(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('text');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const TestPage();
            },
          ),
        );
      },
      child: const Text('Test Page'),
    );
  }

  AppBar _devAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Dev Page - Tap to copy'),
      leading: IconButton(
        onPressed: () {
          context.go('/home');
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        // btn change token
        IconButton(
          onPressed: () {
            sl<SecureStorageHelper>()
                .saveOrUpdateAccessToken(
                    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2MSIsImlhdCI6MTcxMjY2MzE4NCwiZXhwIjoxNzEyNzIzMTg0fQ.njQ0wEqDXmthW5kz7q2s_g-5Ot0CrMnb_6rrmqnUkfU')
                .then((_) => Fluttertoast.showToast(msg: 'expired token has been set'));
          },
          icon: const Icon(Icons.device_unknown),
        ),
      ],
    );
  }

  FutureBuilder<List<Role>?> _buildRoles() {
    return FutureBuilder(
      future: sl<SecureStorageHelper>().roles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final roles = snapshot.data!;
          return Text('${roles.length} Roles: $roles');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  TextField _buildForceChangeAccessToken() {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'forceAccessToken',
        suffixIcon: IconButton(
          onPressed: () async {
            if (forceAccessToken != null) {
              final oldAccessToken = await sl<SecureStorageHelper>().accessToken;
              if (oldAccessToken != null) {
                // final newAuth = auth.copyWith(accessToken: forceAccessToken!);

                log('authBeforeSet: $oldAccessToken');
                await sl<SecureStorageHelper>().saveOrUpdateAccessToken(forceAccessToken ?? '');
                final authAfterSet = await sl<SecureStorageHelper>().accessToken;

                log('authAfterSet: $authAfterSet');

                Fluttertoast.showToast(msg: 'forceAccessToken has been set');
              }
            }
          },
          icon: const Icon(Icons.save),
        ),
      ),
      onChanged: (value) {
        setState(() {
          forceAccessToken = value;
        });
      },
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

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final dio = Dio();
  String? token;

  @override
  void initState() {
    super.initState();
    dio.options.baseUrl = 'http://$devDOMAIN:$kPORT/api';

    dio.interceptors.add(AuthInterceptor());
    // dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   responseBody: true,
    //   requestBody: false,
    //   requestHeader: true,
    //   responseHeader: false,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                dio.get(
                  kAPINotificationGetPageURL,
                  queryParameters: {
                    'page': 1,
                    'size': 10,
                  },
                ).then(
                  (value) {
                    log('result: ${value.data}');
                  },
                );
                // dio
                //     .get('https://661931f99a41b1b3dfbf2dfd.mockapi.io/api/demo')
                //     .then((value) => log('result: ${value.data}'));

                // dio
                //     .get('https://661931f99a41b1b3dfbf2dfd.mockapi.io/api/refreshToken')
                //     .then((value) => log('result: ${value.data}'));
              },
              child: const Text('Notification Get Page'),
            ),
            ElevatedButton(
              onPressed: () {
                sl<SharedPreferencesHelper>().I.setString('token', 'oldToken').then((value) => log(
                      value.toString(),
                    ));
              },
              child: const Text('set old token'),
            ),
            ElevatedButton(
              onPressed: () {
                log('${sl<SharedPreferencesHelper>().I.getString('token')}');
              },
              child: const Text('get token'),
            ),
          ],
        ),
      ),
    );
  }
}



// expired token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2MSIsImlhdCI6MTcxMjY2MzE4NCwiZXhwIjoxNzEyNzIzMTg0fQ.njQ0wEqDXmthW5kz7q2s_g-5Ot0CrMnb_6rrmqnUkfU
