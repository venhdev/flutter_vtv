import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/home/domain/repository/product_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/dto/comment_param.dart';

final _dummy = List<CommentEntity>.generate(
  10,
  (index) => CommentEntity(
    commentId: 'commentId $index',
    content: 'content $index',
    status: Status.ACTIVE,
    createDate: DateTime.now().add(Duration(seconds: index)),
    username: 'username $index',
    shopName: 'shopName $index',
  ),
);

// Page that customer can add their comment to a review
class ReviewDetailPage extends StatefulWidget {
  const ReviewDetailPage({super.key, required this.reviewId});

  static const String routeName = 'review-detail';
  static const String path = '/home/product/review/review-detail';

  final String reviewId;

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  late CommentParam _commentParam;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _commentParam = CommentParam(
      content: '',
      reviewId: widget.reviewId,
      shop: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // List of comments
          Expanded(
            child: ListView.builder(
              itemCount: _dummy.length,
              itemBuilder: (context, index) {
                final comment = _dummy[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: CommentItem(comment),
                  child: Text(comment.content),
                );
              },
            ),
          ),

          // Add comment
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _commentParam = _commentParam.copyWith(content: value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nhập bình luận',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _sending = true;
                    });
                    final respEither = await sl<ProductRepository>().addCustomerComment(_commentParam);
                    respEither.fold(
                      (error) {
                        Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
                      },
                      (resp) {
                        Fluttertoast.showToast(msg: 'Bình luận thành công');
                        setState(() {
                          _dummy.add(
                            CommentEntity(
                              commentId: resp.data?.commentId ?? 'no id',
                              content: _commentParam.content,
                              status: Status.ACTIVE,
                              createDate: DateTime.now(),
                              username: resp.data?.username ?? 'no username',
                              shopName: resp.data?.shopName ?? 'no shop name',
                            ),
                          );
                          _sending = false;
                        });
                      },
                    );
                  },
                  icon: _sending ? const CircularProgressIndicator() : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
