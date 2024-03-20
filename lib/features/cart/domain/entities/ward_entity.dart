import 'dart:convert';

import 'package:equatable/equatable.dart';

class WardEntity extends Equatable {
  final String wardCode;
  final String name;
  final String fullName;
  final String administrativeUnitShortName;

  const WardEntity({
    required this.wardCode,
    required this.name,
    required this.fullName,
    required this.administrativeUnitShortName,
  });

  factory WardEntity.fromMap(Map<String, dynamic> data) => WardEntity(
        wardCode: data['wardCode'] as String,
        name: data['name'] as String,
        fullName: data['fullName'] as String,
        administrativeUnitShortName:
            data['administrativeUnitShortName'] as String,
      );

  Map<String, dynamic> toMap() => {
        'wardCode': wardCode,
        'name': name,
        'fullName': fullName,
        'administrativeUnitShortName': administrativeUnitShortName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WardEntity].
  factory WardEntity.fromJson(String data) {
    return WardEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WardEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  WardEntity copyWith({
    String? wardCode,
    String? name,
    String? fullName,
    String? administrativeUnitShortName,
  }) {
    return WardEntity(
      wardCode: wardCode ?? this.wardCode,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      administrativeUnitShortName:
          administrativeUnitShortName ?? this.administrativeUnitShortName,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      wardCode,
      name,
      fullName,
      administrativeUnitShortName,
    ];
  }
}
