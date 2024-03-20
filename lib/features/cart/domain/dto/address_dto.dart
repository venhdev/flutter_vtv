import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddressDTO extends Equatable {
  final int? addressId;
  final String? provinceName;
  final String? provinceFullName;
  final String? districtName;
  final String? districtFullName;
  final String? wardName;
  final String? wardFullName;
  final String? fullAddress;
  final String? fullName;
  final String? phone;
  final String? status;
  final String? wardCode;

  const AddressDTO({
    this.addressId,
    this.provinceName,
    this.provinceFullName,
    this.districtName,
    this.districtFullName,
    this.wardName,
    this.wardFullName,
    this.fullAddress,
    this.fullName,
    this.phone,
    this.status,
    this.wardCode,
  });

  factory AddressDTO.fromMap(Map<String, dynamic> data) => AddressDTO(
        addressId: data['addressId'] as int?,
        provinceName: data['provinceName'] as String?,
        provinceFullName: data['provinceFullName'] as String?,
        districtName: data['districtName'] as String?,
        districtFullName: data['districtFullName'] as String?,
        wardName: data['wardName'] as String?,
        wardFullName: data['wardFullName'] as String?,
        fullAddress: data['fullAddress'] as String?,
        fullName: data['fullName'] as String?,
        phone: data['phone'] as String?,
        status: data['status'] as String?,
        wardCode: data['wardCode'] as String?,
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
  /// Parses the string and returns the resulting Json object as [AddressDTO].
  factory AddressDTO.fromJson(String data) {
    return AddressDTO.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddressDTO] to a JSON string.
  String toJson() => json.encode(toMap());

  AddressDTO copyWith({
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
    return AddressDTO(
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
