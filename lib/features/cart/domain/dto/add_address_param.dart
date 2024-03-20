import 'package:equatable/equatable.dart';

class AddAddressParam extends Equatable {
  final String? provinceName;
  final String? districtName;
  final String? wardName;
  final String? fullAddress;
  final String? fullName;
  final String? phone;
  final String? wardCode;

  const AddAddressParam({
    this.provinceName,
    this.districtName,
    this.wardName,
    this.fullAddress,
    this.fullName,
    this.phone,
    this.wardCode,
  });

  factory AddAddressParam.fromJson(Map<String, dynamic> json) {
    return AddAddressParam(
      provinceName: json['provinceName'] as String?,
      districtName: json['districtName'] as String?,
      wardName: json['wardName'] as String?,
      fullAddress: json['fullAddress'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      wardCode: json['wardCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'provinceName': provinceName,
        'districtName': districtName,
        'wardName': wardName,
        'fullAddress': fullAddress,
        'fullName': fullName,
        'phone': phone,
        'wardCode': wardCode,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      provinceName,
      districtName,
      wardName,
      fullAddress,
      fullName,
      phone,
      wardCode,
    ];
  }
}
