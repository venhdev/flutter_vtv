import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/home/domain/repository/product_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/dto/comment_param.dart';
import '../components/comment/comment_item.dart';

// final _dummy = List<CommentEntity>.generate(
//   30,
//   (index) => CommentEntity(
//     commentId: 'commentId $index',
//     content: 'content $index',
//     status: Status.ACTIVE,
//     createDate: DateTime.now().add(Duration(seconds: index)),
//     username: 'username $index',
//     shopName: 'shopName $index',
//   ),
// );

//! ReviewDetailPage show all comments of a review, customer can:
// - View all comments
// - Add their comment
class ReviewDetailPage extends StatefulWidget {
  const ReviewDetailPage({
    super.key,
    required this.reviewId,
    this.review,
  }); // assert(reviewId != null || comments != null, 'reviewId or comments must not be null');

  static const String routeName = 'review-detail';
  static const String path = '/home/product/review/review-detail';

  final String reviewId;
  // final List<CommentEntity>? comments;
  final ReviewEntity? review;

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  String errMsg = '';

  late List<CommentEntity> _comments;
  late ReviewEntity _review;
  String? _username;

  bool _sending = false;
  bool _loading = false;

  void fetchData(String reviewId) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final respEither = await sl<ProductRepository>().getReviewDetailByReviewId(reviewId);
    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
        if (mounted) {
          setState(() {
            // _comments = [];
            _loading = false;
            errMsg = error.message ?? 'Có lỗi xảy ra';
          });
        }
      },
      (ok) async {
        _review = ok.data!;

        //! Because API do not return comments, we need to call another API to get comments
        final commentsEither = await sl<ProductRepository>().getReviewComments(reviewId);
        commentsEither.fold(
          (error) {},
          (ok) {
            if (mounted) {
              setState(() {
                _comments = ok.data!.reversed.toList();
                _loading = false;
              });
            }
          },
        );
      },
    );
  }

  void handleSendComment() async {
    if (_commentController.text.isEmpty) return; // ignore empty comment

    setState(() {
      _sending = true;
    });

    final respEither = await sl<ProductRepository>().addCustomerComment(
      CommentParam(
        content: _commentController.text,
        reviewId: widget.reviewId,
        shop: false,
      ),
    );
    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
        setState(() {
          _sending = false;
        });
      },
      (ok) {
        // Fluttertoast.showToast(msg: ok.message ?? 'Bình luận thành công!');
        // final newCmt = CommentEntity(
        //   commentId: resp.data?.commentId ?? 'no id',
        //   content: _commentController.text,
        //   status: Status.ACTIVE,
        //   createDate: DateTime.now(),
        //   username: resp.data?.username ?? 'no username',
        //   shopName: resp.data?.shopName ?? 'no shop name',
        // );

        final newCmt = ok.data!;
        _comments.insert(0, newCmt); // add last
        _commentController.clear();

        if (_comments.length > 1) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        setState(() {
          _sending = false;
        });
      },
    );
  }

  void handleDeleteComment(String commentId) async {
    final respEither = await sl<ProductRepository>().deleteCustomerComment(commentId);
    respEither.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
      },
      (ok) {
        Fluttertoast.showToast(msg: ok.message ?? 'Xóa bình luận thành công!');
        _comments.removeWhere((element) => element.commentId == commentId);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _username = context.read<AuthCubit>().state.auth?.userInfo.username;

    if (widget.review == null) {
      fetchData(widget.reviewId);
    } else {
      // reverse list to archive UX
      // _comments = widget.comments!.reversed.toList();
      _review = widget.review!;
      _comments = widget.review!.comments!.reversed.toList();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }

    // //.?? add delay to scroll to bottom because the list is not ready yet
    // Future.delayed(Duration.zero, () {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Bình luận')),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //# List of comments
                _buildComments(_username),
                //# Add comment text field
                _username == _review.username ? _buildTextField() : const SizedBox.shrink(),
              ],
            ),
    );
  }

  Widget _buildComments(String? username) {
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          height: double.infinity,
          width: double.infinity,
          child: Align(
            alignment: Alignment.topCenter,
            child: _comments.isEmpty
                ? const Center(
                    child: Text('Chưa có bình luận nào'),
                  )
                : ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return CommentItem(
                        comment: _comments[index],
                        isOwner: username == _review.username,
                        handleDeleteComment: handleDeleteComment,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              onSubmitted: (_) => handleSendComment(),
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                hintText: 'Nhập bình luận',
              ),
            ),
          ),
          IconButton(
            onPressed: _sending ? null : handleSendComment,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
