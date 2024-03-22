import 'dart:convert';

import 'package:equatable/equatable.dart';

class DistrictEntity extends Equatable {
  final String districtCode;
  final String name;
  final String fullName;
  final String administrativeUnitShortName;

  const DistrictEntity({
    required this.districtCode,
    required this.name,
    required this.fullName,
    required this.administrativeUnitShortName,
  });

  factory DistrictEntity.fromMap(Map<String, dynamic> data) {
    return DistrictEntity(
      districtCode: data['districtCode'] as String,
      name: data['name'] as String,
      fullName: data['fullName'] as String,
      administrativeUnitShortName:
          data['administrativeUnitShortName'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'districtCode': districtCode,
        'name': name,
        'fullName': fullName,
        'administrativeUnitShortName': administrativeUnitShortName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DistrictEntity].
  factory DistrictEntity.fromJson(String data) {
    return DistrictEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DistrictEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  DistrictEntity copyWith({
    String? districtCode,
    String? name,
    String? fullName,
    String? administrativeUnitShortName,
  }) {
    return DistrictEntity(
      districtCode: districtCode ?? this.districtCode,
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
      districtCode,
      name,
      fullName,
      administrativeUnitShortName,
    ];
  }
}
