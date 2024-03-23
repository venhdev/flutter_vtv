import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int addressId;
  final String provinceName;
  final String provinceFullName;
  final String districtName;
  final String districtFullName;
  final String wardName;
  final String wardFullName;
  final String fullAddress;
  final String fullName;
  final String phone;
  final String status;
  final String wardCode;

  const AddressEntity({
    required this.addressId,
    required this.provinceName,
    required this.provinceFullName,
    required this.districtName,
    required this.districtFullName,
    required this.wardName,
    required this.wardFullName,
    required this.fullAddress,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.wardCode,
  });

  factory AddressEntity.fromMap(Map<String, dynamic> data) => AddressEntity(
        addressId: data['addressId'] as int,
        provinceName: data['provinceName'] as String,
        provinceFullName: data['provinceFullName'] as String,
        districtName: data['districtName'] as String,
        districtFullName: data['districtFullName'] as String,
        wardName: data['wardName'] as String,
        wardFullName: data['wardFullName'] as String,
        fullAddress: data['fullAddress'] as String,
        fullName: data['fullName'] as String,
        phone: data['phone'] as String,
        status: data['status'] as String,
        wardCode: data['wardCode'] as String,
      );

  Map<String, dynamic> toMap() => {
        'addressId': addressId,
        'provinceName': provinceName,
        'provinceFullName': provinceFullName,
        'districtName': districtName,
        'districtFullName': districtFullName,
        'wardName': wardName,
        'wardFullName': wardFullName,
        'fullAddress': fullAddress,
        'fullName': fullName,
        'phone': phone,
        'status': status,
        'wardCode': wardCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddressEntity].
  factory AddressEntity.fromJson(String data) {
    return AddressEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddressEntity] to a JSON string.
  String toJson() => json.encode(toMap());

  AddressEntity copyWith({
    int? addressId,
    String? provinceName,
    String? provinceFullName,
    String? districtName,
    String? districtFullName,
    String? wardName,
    String? wardFullName,
    String? fullAddress,
    String? fullName,
    String? phone,
    String? status,
    String? wardCode,
  }) {
    return AddressEntity(
      addressId: addressId ?? this.addressId,
      provinceName: provinceName ?? this.provinceName,
      provinceFullName: provinceFullName ?? this.provinceFullName,
      districtName: districtName ?? this.districtName,
      districtFullName: districtFullName ?? this.districtFullName,
      wardName: wardName ?? this.wardName,
      wardFullName: wardFullName ?? this.wardFullName,
      fullAddress: fullAddress ?? this.fullAddress,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      wardCode: wardCode ?? this.wardCode,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      addressId,
      provinceName,
      provinceFullName,
      districtName,
      districtFullName,
      wardName,
      wardFullName,
      fullAddress,
      fullName,
      phone,
      status,
      wardCode,
    ];
  }
}
