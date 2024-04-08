// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../../core/base/base_lazy_load_entity.dart';
import 'notification_entity.dart';

class NotificationResp extends IBasePageResp<NotificationEntity> {
  final String status;
  final String message;
  final int code;
  // final List<NotificationEntity> notifications;

  const NotificationResp({
    required this.status,
    required this.message,
    required this.code,
    required super.count,
    required super.page,
    required super.size,
    required super.totalPage,
    required super.listItem,
  });

  @override
  List<Object?> get props {
    return [
      status,
      message,
      code,
      count,
      page,
      size,
      totalPage,
      // notifications,
    ];
  }

  NotificationResp copyWith({
    String? status,
    String? message,
    int? code,
    int? count,
    int? page,
    int? size,
    int? totalPage,
    List<NotificationEntity>? listItem,
  }) {
    return NotificationResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      listItem: listItem ?? this.listItem,
      // notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'code': code,
      'count': count,
      'page': page,
      'size': size,
      'totalPage': totalPage,
      'notificationDTOs': listItem.map((x) => x.toMap()).toList(),
    };
  }

  factory NotificationResp.fromMap(Map<String, dynamic> map) {
    return NotificationResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      count: map['count'] as int,
      page: map['page'] as int,
      size: map['size'] as int,
      totalPage: map['totalPage'] as int,
      listItem: List<NotificationEntity>.from(
        (map['notificationDTOs'] as List<dynamic>).map<NotificationEntity>(
          (x) => NotificationEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationResp.fromJson(String source) =>
      NotificationResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
