import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => context.go('/user/login'),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => context.go('/user/change-password'),
                child: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
