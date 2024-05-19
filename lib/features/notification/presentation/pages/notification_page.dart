import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../core/handler/customer_handler.dart';
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
  late LazyListController<NotificationEntity> _lazyListController;

  @override
  void initState() {
    super.initState();
    _lazyListController = LazyListController<NotificationEntity>.sliver(
      items: [],
      paginatedData: (page) => sl<NotificationRepository>().getPageNotifications(page, _notificationPerPage),
      scrollController: ScrollController(),
      itemBuilder: (_, index, data) => notificationItem(data, index),
      showLoadingIndicator: true,
    )..init();
  }

  NotificationItem notificationItem(NotificationEntity data, int index) {
    void handleRead() async {
      if (data.seen) return; // Already read
      final resultEither = await sl<NotificationRepository>().markAsRead(data.notificationId);

      resultEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
        },
        (ok) {
          log('${ok.message}');
          _lazyListController.updateAt(index, data.copyWith(seen: true));
        },
      );
    }

    return NotificationItem(
      notification: data,
      onPressed: (notificationId) {
        handleRead();
        final orderId = ConversionUtils.extractUUID(data.body);
        if (orderId != null) CustomerHandler.navigateToOrderDetailPage(context, orderId: orderId);
      },
      onExpandPressed: handleRead,
      onConfirmDismiss: (notificationId) async {
        final resultEither = await sl<NotificationRepository>().deleteNotification(notificationId);

        return resultEither.fold(
          (error) {
            return false;
          },
          (ok) {
            log('${ok.message}');
            _lazyListController.removeAt(index);
            return true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(lazyListController: _lazyListController),
    );
  }
}

// dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, _notificationPerPage),
// markAsRead: (id) async {
//   final resultEither = await sl<NotificationRepository>().markAsRead(id);

//   resultEither.fold(
//     (error) {
//       Fluttertoast.showToast(msg: '${error.message}');
//     },
//     (ok) {
//       _lazyListController.reload(newItems: ok.data!.items);
//     },
//   );f
// },
// deleteNotification: (id, index) async {
//   final resultEither = await sl<NotificationRepository>().deleteNotification(id);

//   return resultEither.fold(
//     (error) {
//       return false;
//     },
//     (ok) {
//       _lazyListController.removeAt(index);
//       return true;
//     },
//   );
// },