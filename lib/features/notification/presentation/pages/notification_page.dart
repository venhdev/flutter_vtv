import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/notification_repository.dart';
import '../components/notification_list.dart';

const int _notificationPerPage = 20;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const String routeRoot = '/notification';
  static const String routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(
        dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, _notificationPerPage),
      ),
    );
  }
}
