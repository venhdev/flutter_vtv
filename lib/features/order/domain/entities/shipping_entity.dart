// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShippingEntity extends Equatable {
  final int transportProviderId;
  final String transportProviderFullName;
  final String transportProviderShortName;
  final int shippingCost;
  final String estimatedDeliveryTime;
  final String timestamp;

  const ShippingEntity({
    required this.transportProviderId,
    required this.transportProviderFullName,
    required this.transportProviderShortName,
    required this.shippingCost,
    required this.estimatedDeliveryTime,
    required this.timestamp,
  });

  ShippingEntity copyWith({
    int? transportProviderId,
    String? transportProviderFullName,
    String? transportProviderShortName,
    int? shippingCost,
    String? estimatedDeliveryTime,
    String? timestamp,
  }) {
    return ShippingEntity(
      transportProviderId: transportProviderId ?? this.transportProviderId,
      transportProviderFullName: transportProviderFullName ?? this.transportProviderFullName,
      transportProviderShortName: transportProviderShortName ?? this.transportProviderShortName,
      shippingCost: shippingCost ?? this.shippingCost,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transportProviderId': transportProviderId,
      'transportProviderFullName': transportProviderFullName,
      'transportProviderShortName': transportProviderShortName,
      'shippingCost': shippingCost,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'timestamp': timestamp,
    };
  }

  factory ShippingEntity.fromMap(Map<String, dynamic> map) {
    return ShippingEntity(
      transportProviderId: map['transportProviderId'] as int,
      transportProviderFullName: map['transportProviderFullName'] as String,
      transportProviderShortName: map['transportProviderShortName'] as String,
      shippingCost: map['shippingCost'] as int,
      estimatedDeliveryTime: map['estimatedDeliveryTime'] as String,
      timestamp: map['timestamp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingEntity.fromJson(String source) =>
      ShippingEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      transportProviderId,
      transportProviderFullName,
      transportProviderShortName,
      shippingCost,
      estimatedDeliveryTime,
      timestamp,
    ];
  }
}
