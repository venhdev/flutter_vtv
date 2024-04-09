import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/notification_repository.dart';
import '../components/notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const String routeRoot = '/notification';
  static const String routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: const Text('Thông báo'),
        showSearchBar: false,
        scrolledUnderElevation: 0,
        pushOnNav: true,
      ),
      body: Builder(builder: (context) {
        final controller = LazyLoadController<NotificationEntity>(
          items: [],
          scrollController: ScrollController(),
          useGrid: false,
          emptyMessage: 'Không có thông báo nào.',
        );
        return ListView(
          controller: controller.scrollController,
          children: [
            _buildReadAllAndReloadBtn(controller),
            Divider(height: 0, thickness: 1, color: Colors.grey.shade300),
            NestedLazyLoadBuilder(
              controller: controller,
              dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, 10),
              itemBuilder: (_, __, data) {
                return NotificationItem(notification: data);
              },
              crossAxisCount: 1,
            ),
          ],
        );
      }),
    );
  }

  Row _buildReadAllAndReloadBtn(LazyLoadController<NotificationEntity> controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // context.go('/notification/all');
          },
          child: const Text('Đánh dấu tất cả đã đọc'),
        ),

        // reload
        IconButton(
          onPressed: () {
            controller.reload();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
