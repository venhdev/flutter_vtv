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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            controller.reload();
          } else if (state.status == AuthStatus.unauthenticated) {
            controller.clearItemsNoReload();
          }
        },
        builder: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            return const Center(
              child: Text('Vui lòng đăng nhập để xem thông báo'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              controller.reload();
            },
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                _buildBody(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverList _buildBody(LazyLoadController<NotificationEntity> controller) {
    return SliverList(
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
                          controller.reload(newItems: ok.data!.items);
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
                          // controller.reload(newItems: ok.data.items);
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
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('Thông báo'),
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      actions: const [CartBadge(), SizedBox(width: 8)],
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
