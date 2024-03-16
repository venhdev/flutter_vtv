import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/auth_entity.dart';
import '../../../../core/presentation/components/app_bar.dart';

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({
    super.key,
    required this.auth,
  });

  final AuthEntity auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, showSettingButton: true, showSearchBar: false, title: 'User'),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              context.go('/user/user-detail', extra: auth.userInfo);
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
                      '${auth.userInfo.fullName!} (${auth.userInfo.username!})',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
