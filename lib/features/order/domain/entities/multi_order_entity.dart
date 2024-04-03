
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order_entity.dart';

class MultiOrderEntity extends Equatable {
  final List<OrderEntity> orders;
  // final ShippingEntity shipping;

  const MultiOrderEntity({
    required this.orders,
    // required this.shipping,
  });

  MultiOrderEntity copyWith({
    String? status,
    String? message,
    int? code,
    List<OrderEntity>? orders,
  }) {
    return MultiOrderEntity(
      orders: orders ?? this.orders,
      // shipping: shipping ?? this.shipping,
    );
  }

  factory MultiOrderEntity.fromMap(Map<String, dynamic> map) {
    return MultiOrderEntity(
      orders: (map['orderDTOs'] as List<dynamic>)
          .map(
            (e) => OrderEntity.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  factory MultiOrderEntity.fromJson(String source) => MultiOrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      orders,
      // shipping,
    ];
  }

  @override
  bool get stringify => true;
}
