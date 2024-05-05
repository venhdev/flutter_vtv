import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';

import '../../../service_locator.dart';
import 'customer_login_page.dart';

class CustomerForgotPasswordPage extends StatelessWidget {
  const CustomerForgotPasswordPage({super.key});

  static const String routeName = 'forgot-password';
  static const String path = '/user/login/forgot-password';

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordPage(
      onSendCode: (username) {
        return sl<AuthRepository>().sendOTPForResetPassword(username).then((resultEither) {
          return resultEither.fold(
            (error) => false,
            (ok) => true,
          );
        });
      },
      handleResetPassword: (username, otp, newPass) {
        return sl<AuthRepository>().resetPasswordViaOTP(username, otp, newPass).then((resultEither) {
          return resultEither.fold(
            (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi đổi mật khẩu!'),
            (ok) {
              Fluttertoast.showToast(msg: ok.message ?? 'Đổi mật khẩu thành công!');
              context.go(CustomerLoginPage.path);
            },
          );
        });
      },
    );
  }
}
