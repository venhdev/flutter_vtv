import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
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
          ],
        ),
      ),
    );
  }
}
