import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../../service_locator.dart';
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
          _buildUserInfo(),

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

  Row _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
            ),
            const SizedBox(width: 8),
            if (comment.username.isNotEmpty) _username(comment.username),
            if (comment.shopName.isNotEmpty) _username(comment.shopName),
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

  Widget _username(String username) => FutureBuilder(
      future: sl<SecureStorageHelper>().username,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data == comment.username ? 'Bạn' : comment.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }
        return const SizedBox();
      });
}
