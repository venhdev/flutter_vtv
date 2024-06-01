import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/customer_login_page.dart';
import '../constants/global_variables.dart';

class CustomerRedirect extends BaseRedirect {
  // CustomerRedirect({required super.redirect});

  CustomerRedirect({Map<dynamic, void Function()>? redirect})
      : super(
          redirect: {
            AuthRedirect.loginSuccess: () {
              GlobalVariables.navigatorState.currentContext?.go('/home');
            },
            AuthRedirect.logoutSuccess: () {
              GlobalVariables.navigatorState.currentContext?.go(CustomerLoginPage.path);
            },
            AuthRedirect.registerSuccess: () {
              GlobalVariables.navigatorState.currentContext?.go(CustomerLoginPage.path);
            },
          }..addAll(redirect ?? {}),
        );
}
