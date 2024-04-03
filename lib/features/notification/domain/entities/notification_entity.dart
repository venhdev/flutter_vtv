// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String notificationId;
  final String title;
  final String body;
  final String recipient;
  final String sender;
  final String type;
  final bool seen;
  final DateTime createAt;

  const NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.recipient,
    required this.sender,
    required this.type,
    required this.seen,
    required this.createAt,
  });

  @override
  List<Object> get props {
    return [
      notificationId,
      title,
      body,
      recipient,
      sender,
      type,
      seen,
      createAt,
    ];
  }

  NotificationEntity copyWith({
    String? notificationId,
    String? title,
    String? body,
    String? recipient,
    String? sender,
    String? type,
    bool? seen,
    DateTime? createAt,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      recipient: recipient ?? this.recipient,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      seen: seen ?? this.seen,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'recipient': recipient,
      'sender': sender,
      'type': type,
      'seen': seen,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      notificationId: map['notificationId'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      recipient: map['recipient'] as String,
      sender: map['sender'] as String,
      type: map['type'] as String,
      seen: map['seen'] as bool,
      createAt: DateTime.parse(map['createAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationEntity.fromJson(String source) =>
      NotificationEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
