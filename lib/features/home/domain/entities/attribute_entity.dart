import 'dart:convert';

class AttributeEntity {
  final int attributeId;
  final String name;
  final String value;
  final bool active;
  final int shopId;
  AttributeEntity({
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

  factory AttributeEntity.fromJson(String source) => AttributeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<AttributeEntity> fromList(List<dynamic> map) {
    return List<AttributeEntity>.from(
      map.map<AttributeEntity>(
        (x) => AttributeEntity.fromMap(x),
      ),
    );
  }

  @override
  String toString() {
    return 'AttributeEntity(attributeId: $attributeId, name: $name, value: $value, active: $active, shopId: $shopId)';
  }

  @override
  bool operator ==(covariant AttributeEntity other) {
    if (identical(this, other)) return true;

    return other.attributeId == attributeId &&
        other.name == name &&
        other.value == value &&
        other.active == active &&
        other.shopId == shopId;
  }

  @override
  int get hashCode {
    return attributeId.hashCode ^ name.hashCode ^ value.hashCode ^ active.hashCode ^ shopId.hashCode;
  }
}
