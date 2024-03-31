// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class VoucherOrderEntity extends Equatable {
  final int? voucherOrderId;
  final int? voucherId;
  final String? voucherName;
  final bool? type; // true: shop, false: system
  final String? orderId;

  const VoucherOrderEntity({
    required this.voucherOrderId,
    required this.voucherId,
    required this.voucherName,
    required this.type,
    required this.orderId,
  });

  factory VoucherOrderEntity.empty({String? withName}) {
    return VoucherOrderEntity(
      voucherOrderId: null,
      voucherId: null,
      voucherName: withName,
      type: null,
      orderId: null,
    );
  }

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

  static List<VoucherOrderEntity> fromList(List<dynamic> mapList) {
    return List<VoucherOrderEntity>.from(
      mapList.map((x) => VoucherOrderEntity.fromMap(x)),
    );
  }

  factory VoucherOrderEntity.fromMap(Map<String, dynamic> map) {
    return VoucherOrderEntity(
      voucherOrderId: map['voucherOrderId'] != null ? map['voucherOrderId'] as int : null,
      voucherId: map['voucherId'] as int,
      voucherName: map['voucherName'] as String,
      type: map['type'] as bool,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
    );
  }

  factory VoucherOrderEntity.fromJson(String source) =>
      VoucherOrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoucherOrderEntity(voucherOrderId: $voucherOrderId, voucherId: $voucherId, voucherName: $voucherName, type: $type, orderId: $orderId)';
  }

  @override
  List<Object?> get props {
    return [
      voucherOrderId,
      voucherId,
      voucherName,
      type,
      orderId,
    ];
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

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
}
