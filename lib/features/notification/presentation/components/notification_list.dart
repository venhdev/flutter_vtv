import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/cart_badge.dart';
import '../../domain/repository/notification_repository.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({
    super.key,
    required this.dataCallback,
  });

  final FRespData<NotificationResp> Function(int page) dataCallback;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // if (state.status == AuthStatus.authenticated) {
        //   controller.reload();
        // } else if (state.status == AuthStatus.unauthenticated) {
        //   controller.clearItemsNoReload();
        // }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const Center(
            child: Text('Vui lòng đăng nhập để xem thông báo'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            // controller.reload();
          },
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              _buildBody(controller),
            ],
          ),
        );
      },
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
                // dataCallback: (page) => sl<NotificationRepository>().getPageNotifications(page, 20),
                dataCallback: widget.dataCallback,
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
}
