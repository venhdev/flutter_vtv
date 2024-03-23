import 'dart:convert';

import 'package:equatable/equatable.dart';

class VoucherOrderEntity extends Equatable {
  final int voucherOrderId;
  final int voucherId;
  final String voucherName;
  final bool type;
  final String orderId;

  const VoucherOrderEntity({
    required this.voucherOrderId,
    required this.voucherId,
    required this.voucherName,
    required this.type,
    required this.orderId,
  });

  VoucherOrderEntity copyWith({
    int? voucherOrderId,
    int? voucherId,
    String? voucherName,
    bool? type,
    String? orderId,
  }) {
    return VoucherOrderEntity(
      voucherOrderId: voucherOrderId ?? this.voucherOrderId,
      voucherId: voucherId ?? this.voucherId,
      voucherName: voucherName ?? this.voucherName,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'voucherOrderId': voucherOrderId,
      'voucherId': voucherId,
      'voucherName': voucherName,
      'type': type,
      'orderId': orderId,
    };
  }

  factory VoucherOrderEntity.fromMap(Map<String, dynamic> map) {
    return VoucherOrderEntity(
      voucherOrderId: map['voucherOrderId'] as int,
      voucherId: map['voucherId'] as int,
      voucherName: map['voucherName'] as String,
      type: map['type'] as bool,
      orderId: map['orderId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherOrderEntity.fromJson(String source) =>
      VoucherOrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoucherOrderEntity(voucherOrderId: $voucherOrderId, voucherId: $voucherId, voucherName: $voucherName, type: $type, orderId: $orderId)';
  }

  @override
  bool operator ==(covariant VoucherOrderEntity other) {
    if (identical(this, other)) return true;

    return other.voucherOrderId == voucherOrderId &&
        other.voucherId == voucherId &&
        other.voucherName == voucherName &&
        other.type == type &&
        other.orderId == orderId;
  }

  @override
  int get hashCode {
    return voucherOrderId.hashCode ^
        voucherId.hashCode ^
        voucherName.hashCode ^
        type.hashCode ^
        orderId.hashCode;
  }

  @override
  List<Object> get props {
    return [
      voucherOrderId,
      voucherId,
      voucherName,
      type,
      orderId,
    ];
  }
}
