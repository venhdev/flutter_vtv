import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import 'customer_chat_page.dart';

class CustomerChatRoomPage extends StatelessWidget {
  const CustomerChatRoomPage({super.key});

  static const routeName = 'chat-room';
  static const path = '/user/chat-room';

  @override
  Widget build(BuildContext context) {
    final lazyListController = LazyListController<ChatRoomEntity>(
      items: [],
      paginatedData: sl<ChatRepository>().getPageRoomChat,
      itemBuilder: (context, index, data) => chatRoomItem(context, data),
      useGrid: false,
    )..init();

    return ChatRoomPage(lazyListController: lazyListController);
  }

  ChatRoomItem chatRoomItem(BuildContext context, ChatRoomEntity room) {
    return ChatRoomItem(
      room: room,
      onPressed: () {
        context.go(
          BuilderUtils.uriPath(
            path: CustomerChatPage.path,
            queryParameters: {'roomChatId': room.romChatId, 'receiverUsername': room.receiverUsername},
          ),
        );
      },
    );
  }
}
