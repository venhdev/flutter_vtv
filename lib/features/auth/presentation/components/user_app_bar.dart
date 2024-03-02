import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/auth_entity.dart';

AppBar buildUserAppBar(BuildContext context, [AuthEntity? auth]) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    actions: [
      // icon cart
      const IconButton.outlined(
        onPressed: null,
        icon: Icon(Icons.shopping_cart_outlined),
      ),

      // icon chat
      const IconButton.outlined(
        onPressed: null,
        icon: Icon(Icons.chat_outlined),
      ),

      // icon settings
      IconButton.outlined(
        onPressed: () => context.go('/user/settings'),
        icon: const Icon(Icons.settings_outlined),
      ),
    ],

    // bottom
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: InkWell(
        onTap: () {
          if (auth == null) {
            context.go('/user/login');
          } else {
            context.go('/user/user-detail', extra: auth.userInfo);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // avatar
          children: [
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
            ),

            const SizedBox(width: 12),

            // username
            SizedBox(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  auth?.userInfo.username ?? 'Chưa đăng nhập',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
