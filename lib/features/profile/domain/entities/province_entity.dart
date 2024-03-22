import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProvinceEntity extends Equatable {
  final String provinceCode;
  final String name;
  final String fullName;
  final String administrativeUnitShortName;

  const ProvinceEntity({
    required this.provinceCode,
    required this.name,
    required this.fullName,
    required this.administrativeUnitShortName,
  });

  factory ProvinceEntity.fromMap(Map<String, dynamic> data) {
    return ProvinceEntity(
      provinceCode: data['provinceCode'] as String,
      name: data['name'] as String,
      fullName: data['fullName'] as String,
      administrativeUnitShortName:
          data['administrativeUnitShortName'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'provinceCode': provinceCode,
        'name': name,
        'fullName': fullName,
        'administrativeUnitShortName': administrativeUnitShortName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProvinceEntity].
  factory ProvinceEntity.fromJson(String data) {
    return ProvinceEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProvinceEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  ProvinceEntity copyWith({
    String? provinceCode,
    String? name,
    String? fullName,
    String? administrativeUnitShortName,
  }) {
    return ProvinceEntity(
      provinceCode: provinceCode ?? this.provinceCode,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      administrativeUnitShortName:
          administrativeUnitShortName ?? this.administrativeUnitShortName,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      provinceCode,
      name,
      fullName,
      administrativeUnitShortName,
    ];
  }
}
