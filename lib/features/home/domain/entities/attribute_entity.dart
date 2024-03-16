// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AttributeEntity extends Equatable {
  final int attributeId;
  final String name;
  final String value;
  final bool active;
  final int shopId;

  const AttributeEntity({
    required this.attributeId,
    required this.name,
    required this.value,
    required this.active,
    required this.shopId,
  });

  AttributeEntity copyWith({
    int? attributeId,
    String? name,
    String? value,
    bool? active,
    int? shopId,
  }) {
    return AttributeEntity(
      attributeId: attributeId ?? this.attributeId,
      name: name ?? this.name,
      value: value ?? this.value,
      active: active ?? this.active,
      shopId: shopId ?? this.shopId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attributeId': attributeId,
      'name': name,
      'value': value,
      'active': active,
      'shopId': shopId,
    };
  }

  factory AttributeEntity.fromMap(Map<String, dynamic> map) {
    return AttributeEntity(
      attributeId: map['attributeId'].toInt() as int,
      name: map['name'] as String,
      value: map['value'] as String,
      active: map['active'] as bool,
      shopId: map['shopId'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttributeEntity.fromJson(String source) =>
      AttributeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<AttributeEntity> fromList(List<dynamic> map) {
    return List<AttributeEntity>.from(
      map.map<AttributeEntity>(
        (x) => AttributeEntity.fromMap(x),
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      attributeId,
      name,
      value,
      active,
      shopId,
    ];
  }

  @override
  bool get stringify => true;
}
