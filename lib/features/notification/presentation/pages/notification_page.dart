import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../cart/presentation/components/cart_badge.dart';
import '../../domain/repository/notification_repository.dart';
import '../components/notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const String routeRoot = '/notification';
  static const String routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    final controller = LazyLoadController<NotificationEntity>(
      items: [],
      scrollController: ScrollController(),
      useGrid: false,
      emptyMessage: 'Không có thông báo nào',
    );

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            return const Center(
              child: Text('Vui lòng đăng nhập để xem thông báo'),
            );
          }
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Thông báo'),
                pinned: true,
                backgroundColor: Colors.transparent,
                actions: [CartBadge(), SizedBox(width: 8)],
                // bottom: PreferredSize(
                //   preferredSize: const Size.fromHeight(48),
                //   child: Container(
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     child: Column(
                //       children: [
                //         _buildReadAllAndReloadBtn(controller),
                //       ],
                //     ),
                //   ),
                // ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListView(
                      controller: controller.scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        NestedLazyLoadBuilder(
                          controller: controller,
                          dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, 20),
                          itemBuilder: (_, __, data) {
                            return NotificationItem(
                              notification: data,
                              markAsRead: (id) async {
                                final resultEither = await sl<NotificationRepository>().markAsRead(id);

                                resultEither.fold(
                                  (error) {
                                    Fluttertoast.showToast(msg: '${error.message}');
                                  },
                                  (ok) {
                                    controller.reload(newItems: ok.data.listItem);
                                  },
                                );
                              },
                              onDismiss: (id) async {
                                final resultEither = await sl<NotificationRepository>().deleteNotification(id);

                                log('{deleteNotification} resultEither: $resultEither');

                                return resultEither.fold(
                                  (error) {
                                    log('{deleteNotification} Error: ${error.message}');
                                    // Fluttertoast.showToast(msg: '${error.message}');
                                    return false;
                                  },
                                  (ok) {
                                    // controller.reload(newItems: ok.data.listItem);
                                    return true;
                                  },
                                );
                              },
                            );
                          },
                          crossAxisCount: 1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Row _buildReadAllAndReloadBtn(LazyLoadController<NotificationEntity> controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: null, //TODO: implement mark all as read
          style: TextButton.styleFrom(
            backgroundColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Đánh dấu tất cả đã đọc'),
        ),
      ],
    );
  }
}
