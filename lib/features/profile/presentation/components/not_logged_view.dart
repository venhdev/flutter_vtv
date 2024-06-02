import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/customer_login_page.dart';

class NotLoggedView extends StatelessWidget {
  const NotLoggedView({
    super.key,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon user shield
            SvgPicture.asset('assets/svg/user-shield-alt-1.svg'),
            const SizedBox(height: 12),

            // message
            const Text(
              'Đăng nhập để tiếp tục',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // login button
            TextButton(
              onPressed: () => context.go(CustomerLoginPage.path),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
