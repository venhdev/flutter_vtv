import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/notification/local_notification_manager.dart';
import 'package:flutter_vtv/features/order/presentation/pages/purchase_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../service_locator.dart';
import '../../../order/presentation/pages/voucher_page.dart';
import '../../domain/entities/auth_entity.dart';
import '../../../../core/presentation/components/app_bar.dart';

class LoggedView extends StatelessWidget {
  const LoggedView({
    super.key,
    required this.auth,
  });

  final AuthEntity auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, showSettingButton: true, showSearchBar: false, title: 'User'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // user avatar + fullName + username
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

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              context.go(PurchasePage.path);
            },
            child: const Text('Đơn hàng của tôi'),
          ),

          // voucher
          //! DEV
          const Divider(height: 32, thickness: 1, color: Colors.red),
          const Text('DEV'),
          ElevatedButton(
            onPressed: () {
              // debugPrint('text');
              context.go(VoucherPage.path);
            },
            child: const Text('All Vouchers'),
          ),

          ElevatedButton(
            onPressed: () {
              sl<LocalNotificationManager>().showNotification(
                id: 1,
                title: 'Title',
                body: 'Body',
              );
            },
            child: const Text('Notification'),
          ),
        ],
      ),
    );
  }
}
