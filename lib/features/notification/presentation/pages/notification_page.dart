import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/notification_repository.dart';

const int _notificationPerPage = 20;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeRoot = '/notification';
  static const String routeName = 'notification';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late LazyLoadController<NotificationEntity> controller;

  @override
  void initState() {
    super.initState();
    controller = LazyLoadController<NotificationEntity>(
      items: [],
      scrollController: ScrollController(),
      useGrid: false,
      emptyMessage: 'Không có thông báo nào',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(
        dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, _notificationPerPage),
        markAsRead: (id) async {
          final resultEither = await sl<NotificationRepository>().markAsRead(id);

          resultEither.fold(
            (error) {
              Fluttertoast.showToast(msg: '${error.message}');
            },
            (ok) {
              controller.reload(newItems: ok.data!.items);
            },
          );
        },
        deleteNotification: (id, index) async {
          final resultEither = await sl<NotificationRepository>().deleteNotification(id);

          return resultEither.fold(
            (error) {
              return false;
            },
            (ok) {
              controller.removeAt(index);
              return true;
            },
          );
        },
      ),
    );
  }
}
