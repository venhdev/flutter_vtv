// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LoyaltyPointHistoryEntity extends Equatable {
  final int? loyaltyPointHistoryId;
  final int point;
  final String? type;
  final String? status;
  final int loyaltyPointId;
  final DateTime? createAt;

  const LoyaltyPointHistoryEntity({
    this.loyaltyPointHistoryId,
    required this.point,
    required this.type,
    required this.status,
    required this.loyaltyPointId,
    required this.createAt,
  });

  LoyaltyPointHistoryEntity copyWith({
    int? loyaltyPointHistoryId,
    int? point,
    String? type,
    String? status,
    int? loyaltyPointId,
    DateTime? createAt,
  }) {
    return LoyaltyPointHistoryEntity(
      loyaltyPointHistoryId: loyaltyPointHistoryId ?? this.loyaltyPointHistoryId,
      point: point ?? this.point,
      type: type ?? this.type,
      status: status ?? this.status,
      loyaltyPointId: loyaltyPointId ?? this.loyaltyPointId,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loyaltyPointHistoryId': loyaltyPointHistoryId,
      'point': point,
      'type': type,
      'status': status,
      'loyaltyPointId': loyaltyPointId,
      'createAt': createAt?.toIso8601String(),
    };
  }

  factory LoyaltyPointHistoryEntity.fromMap(Map<String, dynamic> map) {
    return LoyaltyPointHistoryEntity(
      loyaltyPointHistoryId: map['loyaltyPointHistoryId'] as int?,
      point: map['point'] as int,
      type: map['type'] as String?,
      status: map['status'] as String?,
      loyaltyPointId: map['loyaltyPointId'] as int,
      createAt: map['createAt'] != null ? DateTime.parse(map['createAt'] as String) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoyaltyPointHistoryEntity.fromJson(String source) =>
      LoyaltyPointHistoryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      loyaltyPointHistoryId,
      point,
      type,
      status,
      loyaltyPointId,
      createAt,
    ];
  }
}
