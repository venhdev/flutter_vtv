import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';

class CustomerChatPage extends StatelessWidget {
  const CustomerChatPage({super.key, required this.room});

  // final String roomChatId;
  // final String receiverUsername;

  final ChatRoomEntity room;

  static String routeName = 'chat';
  // static String routePath = 'chat';
  static String path = '/user/chat-room/chat';

  @override
  Widget build(BuildContext context) {
    final lazyListController = LazyListController<MessageEntity>(
      items: [],
      paginatedData: (page, size) => sl<ChatRepository>().getPageChatMessageByRoomId(page, size, room.roomChatId),
      itemBuilder: (context, index, data) => ChatItem(chat: data),
      useGrid: false,
      auto: true,
      scrollController: ScrollController(),
      reverse: true,
      size: 20,
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final recipient = room.getRecipientForChat(state.auth!.userInfo.username!);

          return Scaffold(
            appBar: AppBar(
              title: Text(recipient),
            ),
            body: ChatPage(
              roomChatId: room.roomChatId,
              receiverUsername: recipient,
              lazyListController: lazyListController,
            ),
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          return const NoPermissionPage();
        } else {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
