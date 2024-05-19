import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/components/app_bar.dart';

class NotLoggedView extends StatelessWidget {
  const NotLoggedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, showSettingButton: true, showSearchBar: false),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon user shield
            SvgPicture.asset('assets/svg/user-shield-alt-1.svg'),
            const SizedBox(height: 12),

            // txt
            const Text(
              'Đăng nhập để tiếp tục',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // login button
            TextButton(
              onPressed: () => context.go('/user/login'),
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
