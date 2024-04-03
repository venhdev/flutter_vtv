import 'package:flutter/material.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../../../../core/presentation/components/custom_widgets.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/notification_repository.dart';
import '../components/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeRoot = '/notification';
  static const String routeName = 'notification';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: const Text('Thông báo'),
        showSearchBar: false,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // context.go('/notification/all');
                },
                child: const Text('Đánh dấu tất cả đã đọc'),
              ),
            ],
          ),
          Divider(height: 0, thickness: 1, color: Colors.grey.shade300),
          Expanded(
            child: FutureBuilder(
              future: sl<NotificationRepository>().getPageNotifications(1, 100), //TODO lazy load
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final resultEither = snapshot.data!;
                  return resultEither.fold(
                    (error) => MessageScreen.error(error.message),
                    (ok) => RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: Builder(builder: (context) {
                        if (ok.data.notifications.isEmpty) {
                          return const MessageScreen(
                            message: 'Không có thông báo nào',
                            enableBack: false,
                            icon: Icon(Icons.notifications_off, size: 52),
                          );
                        }
                        return ListView.builder(
                          itemCount: ok.data.notifications.length,
                          itemBuilder: (context, index) {
                            return NotificationItem(notification: ok.data.notifications[index]);
                          },
                        );
                      }),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return MessageScreen.error(snapshot.error.toString());
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
