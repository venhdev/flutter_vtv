// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class VoucherEntity extends Equatable {
  final int voucherId;
  final String status;
  final String code;
  final String name;
  final String description;
  final int discount;
  final int quantity;
  final DateTime startDate;
  final DateTime endDate;
  final int quantityUsed;
  final String type;

  const VoucherEntity({
    required this.voucherId,
    required this.status,
    required this.code,
    required this.name,
    required this.description,
    required this.discount,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.quantityUsed,
    required this.type,
  });

  @override
  List<Object> get props {
    return [
      voucherId,
      status,
      code,
      name,
      description,
      discount,
      quantity,
      startDate,
      endDate,
      quantityUsed,
      type,
    ];
  }

  VoucherEntity copyWith({
    int? voucherId,
    String? status,
    String? code,
    String? name,
    String? description,
    int? discount,
    int? quantity,
    DateTime? startDate,
    DateTime? endDate,
    int? quantityUsed,
    String? type,
  }) {
    return VoucherEntity(
      voucherId: voucherId ?? this.voucherId,
      status: status ?? this.status,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'voucherId': voucherId,
      'status': status,
      'code': code,
      'name': name,
      'description': description,
      'discount': discount,
      'quantity': quantity,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'quantityUsed': quantityUsed,
      'type': type,
    };
  }

  factory VoucherEntity.fromMap(Map<String, dynamic> map) {
    return VoucherEntity(
      voucherId: map['voucherId'] as int,
      status: map['status'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      discount: map['discount'] as int,
      quantity: map['quantity'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      quantityUsed: map['quantityUsed'] as int,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherEntity.fromJson(String source) => VoucherEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<VoucherEntity> fromList(List<dynamic> list) {
    return list.map((e) => VoucherEntity.fromMap(e)).toList();
  }

  @override
  bool get stringify => true;
}
