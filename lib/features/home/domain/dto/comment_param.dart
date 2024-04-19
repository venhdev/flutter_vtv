// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentParam {
  String content;
  final String reviewId;
  final bool shop;

  CommentParam({
    this.content = '',
    required this.reviewId,
    required this.shop,
  });

  CommentParam copyWith({
    String? content,
    String? reviewId,
    String? username,
    bool? shop,
  }) {
    return CommentParam(
      content: content ?? this.content,
      reviewId: reviewId ?? this.reviewId,
      shop: shop ?? this.shop,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'reviewId': reviewId,
      'shop': shop,
    };
  }

  factory CommentParam.fromMap(Map<String, dynamic> map) {
    return CommentParam(
      content: map['content'] as String,
      reviewId: map['reviewId'] as String,
      shop: map['shop'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentParam.fromJson(String source) => CommentParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant CommentParam other) {
    if (identical(this, other)) return true;

    return other.content == content && other.reviewId == reviewId && other.shop == shop;
  }

  @override
  int get hashCode => content.hashCode ^ reviewId.hashCode ^ shop.hashCode;
}
