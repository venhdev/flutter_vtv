// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';
import 'comment_entity.dart';

class ReviewEntity extends Equatable {
  final String reviewId;
  final String content;
  final int rating;
  final String image;
  final Status status;
  final String username;
  final String orderItemId;
  final DateTime createdAt;
  final int countComment;
  final List<CommentEntity>? comments;

  const ReviewEntity({
    required this.reviewId,
    required this.content,
    required this.rating,
    required this.image,
    required this.status,
    required this.username,
    required this.orderItemId,
    required this.createdAt,
    required this.countComment,
    required this.comments,
  });

  @override
  List<Object?> get props {
    return [
      reviewId,
      content,
      rating,
      image,
      status,
      username,
      orderItemId,
      createdAt,
      countComment,
      comments,
    ];
  }

  ReviewEntity copyWith({
    String? reviewId,
    String? content,
    int? rating,
    String? image,
    Status? status,
    String? username,
    String? orderItemId,
    DateTime? createdAt,
    int? countComment,
    List<CommentEntity>? comments,
  }) {
    return ReviewEntity(
      reviewId: reviewId ?? this.reviewId,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      status: status ?? this.status,
      username: username ?? this.username,
      orderItemId: orderItemId ?? this.orderItemId,
      createdAt: createdAt ?? this.createdAt,
      countComment: countComment ?? this.countComment,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reviewId': reviewId,
      'content': content,
      'rating': rating,
      'image': image,
      'status': status.name,
      'username': username,
      'orderItemId': orderItemId,
      'createdAt': createdAt.toIso8601String(),
      'countComment': countComment,
      'commentDTOs': comments?.map((x) => x.toMap()).toList(),
    };
  }

  factory ReviewEntity.fromMap(Map<String, dynamic> map) {
    return ReviewEntity(
      reviewId: map['reviewId'] as String,
      content: map['content'] as String,
      rating: map['rating'] as int,
      image: map['image'] as String,
      status: Status.values.firstWhere((e) => e.name == map['status'] as String),
      username: map['username'] as String,
      orderItemId: map['orderItemId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      countComment: map['countComment'] as int,
      // comments: List<CommentEntity>.from(
      //   (map['commentDTOs'] as List<dynamic>).map<CommentEntity>(
      //     (x) => CommentEntity.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      comments: (map['commentDTOs'] as List<dynamic>?)
          ?.map<CommentEntity>((x) => CommentEntity.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewEntity.fromJson(String source) => ReviewEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
