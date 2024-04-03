// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';

class CommentEntity extends Equatable {
  final String commentId;
  final String content;
  final Status status;
  final DateTime createDate;
  final String username;
  final String shopName;

  const CommentEntity({
    required this.commentId,
    required this.content,
    required this.status,
    required this.createDate,
    required this.username,
    required this.shopName,
  });

  @override
  List<Object> get props {
    return [
      commentId,
      content,
      status,
      createDate,
      username,
      shopName,
    ];
  }

  CommentEntity copyWith({
    String? commentId,
    String? content,
    Status? status,
    DateTime? createDate,
    String? username,
    String? shopName,
  }) {
    return CommentEntity(
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      status: status ?? this.status,
      createDate: createDate ?? this.createDate,
      username: username ?? this.username,
      shopName: shopName ?? this.shopName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'content': content,
      'status': status.name,
      'createDate': createDate.millisecondsSinceEpoch,
      'username': username,
      'shopName': shopName,
    };
  }

  factory CommentEntity.fromMap(Map<String, dynamic> map) {
    return CommentEntity(
      commentId: map['commentId'] as String,
      content: map['content'] as String,
      status: Status.values.firstWhere((element) => element.name == map['status'] as String),
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      username: map['username'] as String,
      shopName: map['shopName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentEntity.fromJson(String source) => CommentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
