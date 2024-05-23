import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/notification_repository.dart';

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
      paginatedData: (page, size) => sl<NotificationRepository>().getPageNotifications(page, size),
      scrollController: ScrollController(),
      itemBuilder: (_, index, data) => notificationItem(data, index),
      showLoadingIndicator: true,
      lastPageMessage: 'Không có thông báo nào',
    );

    // when user is authenticated, init the lazy list
    // else it will be init when user login (see [NotificationList])
    if (context.read<AuthCubit>().state.status == AuthStatus.authenticated) _lazyListController.init();
  }

  Widget notificationItem(NotificationEntity data, int index) {
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: !data.seen ? Colors.orangeAccent.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black26,
        //     blurRadius: 5.0,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: NotificationItem(
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
      ),
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