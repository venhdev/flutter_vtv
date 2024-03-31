// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final int shopId;
  final String name;
  final String address;
  final String provinceName;
  final String districtName;
  final String wardName;
  final String phone;
  final String email;
  final String avatar;
  final String description;
  final String openTime;
  final String closeTime;
  final String status;
  final int customerId;
  final String wardCode;
  
  const ShopEntity({
    required this.shopId,
    required this.name,
    required this.address,
    required this.provinceName,
    required this.districtName,
    required this.wardName,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.description,
    required this.openTime,
    required this.closeTime,
    required this.status,
    required this.customerId,
    required this.wardCode,
  });
  
  @override
  List<Object> get props {
    return [
      shopId,
      name,
      address,
      provinceName,
      districtName,
      wardName,
      phone,
      email,
      avatar,
      description,
      openTime,
      closeTime,
      status,
      customerId,
      wardCode,
    ];
  }

  ShopEntity copyWith({
    int? shopId,
    String? name,
    String? address,
    String? provinceName,
    String? districtName,
    String? wardName,
    String? phone,
    String? email,
    String? avatar,
    String? description,
    String? openTime,
    String? closeTime,
    String? status,
    int? customerId,
    String? wardCode,
  }) {
    return ShopEntity(
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      address: address ?? this.address,
      provinceName: provinceName ?? this.provinceName,
      districtName: districtName ?? this.districtName,
      wardName: wardName ?? this.wardName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      wardCode: wardCode ?? this.wardCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopId': shopId,
      'name': name,
      'address': address,
      'provinceName': provinceName,
      'districtName': districtName,
      'wardName': wardName,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'description': description,
      'openTime': openTime,
      'closeTime': closeTime,
      'status': status,
      'customerId': customerId,
      'wardCode': wardCode,
    };
  }

  factory ShopEntity.fromMap(Map<String, dynamic> map) {
    return ShopEntity(
      shopId: map['shopId'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      provinceName: map['provinceName'] as String,
      districtName: map['districtName'] as String,
      wardName: map['wardName'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      description: map['description'] as String,
      openTime: map['openTime'] as String,
      closeTime: map['closeTime'] as String,
      status: map['status'] as String,
      customerId: map['customerId'] as int,
      wardCode: map['wardCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopEntity.fromJson(String source) => ShopEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
