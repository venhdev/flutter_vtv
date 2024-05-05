import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';

import '../../../service_locator.dart';

class CustomerChangePasswordPage extends StatelessWidget {
  const CustomerChangePasswordPage({super.key});

  static const String routeName = 'change-password';
  static const String path = '/user/change-password';

  @override
  Widget build(BuildContext context) {
    return ChangePasswordPage(
      onChangePassword: (oldPass, newPass) {
        sl<AuthRepository>().changePassword(oldPass, newPass).then((resultEither) {
          resultEither.fold(
            (error) => Fluttertoast.showToast(msg: 'Đổi mật khẩu thất bại'),
            (ok) => Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công'),
          );
        });
      },
    );
  }
}
