import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vtv_common/auth.dart';

import '../../../service_locator.dart';
import 'customer_login_page.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({super.key});

  static const String routeName = 'register';
  static const String path = '/user/register';

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  int _currentStep = 0;
  String _username = '';
  String _otp = '';
  String _msgFromServer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        controlsBuilder: (context, details) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (_currentStep == 0) const SizedBox.shrink(),
            if (_currentStep == 1)
              (_username.isNotEmpty && _otp.isNotEmpty)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: () {
                        sl<AuthRepository>().activeCustomerAccount(_username, _otp).then((resultEither) {
                          resultEither.fold(
                            (error) {
                              Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi xác nhận email!');
                            },
                            (ok) {
                              Fluttertoast.showToast(msg: ok.message ?? 'Xác nhận email thành công!');
                              context.go(CustomerLoginPage.path);
                            },
                          );
                        });
                      },
                      child: const Text('Xác nhận'),
                    )
                  : const SizedBox.shrink(),
          ],
        ),
        currentStep: _currentStep,
        type: StepperType.horizontal,
        onStepContinue: () {
          if (_currentStep == 0) {
            setState(() {
              _currentStep = 1;
            });
          }
        },
        steps: <Step>[
          Step(
            title: const Text('Thông tin cá nhân'),
            content: registerForm(context),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Xác nhận Email'),
            // content: confirmEmailForm(context),
            content: confirmCode(context),
            isActive: _currentStep >= 1,
          ),
        ],
      ),
    );
  }

  RegisterForm registerForm(BuildContext context) {
    return RegisterForm(
      onRegisterPressed: (params) async {
        return sl<AuthRepository>().register(params).then((resultEither) {
          return resultEither.fold(
            (error) {
              Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi đăng ký tài khoản!');
            },
            (ok) {
              // Fluttertoast.showToast(msg: ok.message ?? 'Đăng ký tài khoản thành công!');
              setState(() {
                _username = params.username;
                _msgFromServer = ok.message ??
                    'Một email xác nhận đã được gửi đến hòm thư của bạn. Vui lòng kiểm tra và nhập mã xác nhận.';
                _currentStep += 1;
              });
            },
          );
        });
      },
      onLoginPressed: () => context.go(CustomerLoginPage.path),
    );
  }

  Widget confirmCode(BuildContext context) {
    final textEditingController = TextEditingController();
    return Column(
      children: [
        Text(
          _msgFromServer,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 20),
        PinCodeTextField(
          appContext: context,
          length: 6,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 200),
          enableActiveFill: true,
          controller: textEditingController,
          keyboardType: TextInputType.number,
          onCompleted: (otp) async {
            setState(() {
              _otp = otp;
            });
          },
          onChanged: (value) {
            if (value.length < 6) {
              setState(() {
                _otp = '';
              });
            }
          },
          beforeTextPaste: (text) {
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            // validation for code paste is number only
            if (text!.contains(RegExp(r'^[0-9]*$'))) {
              log("Allowing to paste $text");
              return true;
            }
            return false;
          },
        ),
      ],
    );
  }
}
