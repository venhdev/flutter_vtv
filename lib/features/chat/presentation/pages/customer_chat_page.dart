import 'package:flutter/material.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';

class CustomerChatPage extends StatelessWidget {
  const CustomerChatPage({super.key, required this.roomChatId, required this.receiverUsername});

  final String roomChatId;
  final String receiverUsername;

  static String routeName = 'chat';
  // static String routePath = 'chat';
  static String path = '/user/chat-room/chat';

  @override
  Widget build(BuildContext context) {
    final lazyListController = LazyListController<MessageEntity>(
      items: [],
      paginatedData: (page, size) => sl<ChatRepository>().getPageChatMessageByRoomId(page, size, roomChatId),
      itemBuilder: (context, index, data) => ChatItem(chat: data),
      useGrid: false,
      auto: true,
      scrollController: ScrollController(),
      reverse: true,
      size: 20,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Chat'),
      ),
      body: ChatPage(
        roomChatId: roomChatId,
        receiverUsername: receiverUsername,
        lazyListController: lazyListController,
      ),
    );
  }
}
