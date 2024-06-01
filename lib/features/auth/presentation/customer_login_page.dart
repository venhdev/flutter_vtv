import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';

import 'customer_forgot_password_page.dart';
import 'customer_register_page.dart';

class CustomerLoginPage extends StatelessWidget {
  const CustomerLoginPage({super.key});

  static const String routeName = 'login';
  static const String path = '/user/login';

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onLoginPressed: (username, password) async {
        context.read<AuthCubit>().loginWithUsernameAndPassword(username: username, password: password);
      },
      onRegisterPressed: () => context.go(CustomerRegisterPage.path),
      onForgotPasswordPressed: () => context.go(CustomerForgotPasswordPage.path),
    );
  }
}
