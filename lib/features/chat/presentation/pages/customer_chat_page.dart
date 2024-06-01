import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';

import '../../../../core/constants/global_variables.dart';
import '../../../../service_locator.dart';

class CustomerChatPage extends StatefulWidget {
  const CustomerChatPage({super.key, required this.room});

  final ChatRoomEntity room;

  static String routeName = 'chat';
  static String path = '/user/chat-room/chat';

  @override
  State<CustomerChatPage> createState() => _CustomerChatPageState();
}

class _CustomerChatPageState extends State<CustomerChatPage> {
  @override
  void initState() {
    super.initState();
    GlobalVariables.currentChatRoomId = widget.room.roomChatId; // track current chat room id for notification
  }

  @override
  void dispose() {
    GlobalVariables.currentChatRoomId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lazyListController = LazyListController<MessageEntity>(
      items: [],
      paginatedData: (page, size) =>
          sl<ChatRepository>().getPaginatedChatMessageByRoomId(page, size, widget.room.roomChatId),
      itemBuilder: (context, index, data) => ChatItem(chat: data),
      useGrid: false,
      auto: true,
      scrollController: ScrollController(),
      reverse: true,
      lastPageMessage: 'Không có tin nhắn nào!',
      size: 20,
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final recipient = widget.room.getRecipientForChat(state.currentUsername!);

          return Scaffold(
            appBar: AppBar(
              title: Text(recipient),
            ),
            body: ChatPage(
              roomChatId: widget.room.roomChatId,
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
