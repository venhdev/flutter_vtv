import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import 'cascading_menu_btn.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
    required this.isOwner,
    required this.handleDeleteComment,
  });

  final CommentEntity comment;
  final bool isOwner;
  final void Function(String commentId) handleDeleteComment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //# user info & more_vert button if owner
          Builder(builder: (context) {
            final currentUsername = context.read<AuthCubit>().state.auth?.userInfo.username;
            return _buildUserInfo(currentUsername);
          }),

          // content
          Text(comment.content),

          // date
          Text(
            StringHelper.convertDateTimeToString(
              comment.createDate,
              pattern: 'dd/MM/yyyy hh:mm aa',
            ),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Row _buildUserInfo(String? currentUsername) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
            ),
            const SizedBox(width: 8),
            if (comment.username.isNotEmpty) _username(comment.username, currentUsername),
            if (comment.shopName.isNotEmpty) _username(comment.shopName, currentUsername),
            // Text(comment.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: () {
        //

        //   },
        // ),
        // show dropdown menu with options: edit, delete

        if (isOwner)
          CascadingMenuBtn(
            activate: (MenuEntry selection) {
              switch (selection) {
                case MenuEntry.deleteComment:
                  handleDeleteComment(comment.commentId);
                  break;
              }
            },
          ),
      ],
    );
  }

  Widget _username(String username, String? curUsername) => Text(
        curUsername == comment.username ? 'Bạn' : comment.username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
}
