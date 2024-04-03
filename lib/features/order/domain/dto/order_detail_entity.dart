// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../entities/order_entity.dart';
import '../entities/shipping_entity.dart';

//! OrderResp with one OrderEntity
//! MultiOrderResp with List<OrderEntity>
class OrderDetailEntity extends Equatable {
  final OrderEntity order;
  final ShippingEntity shipping;

  const OrderDetailEntity({
    required this.order,
    required this.shipping,
  });

  OrderDetailEntity copyWith({
    String? status,
    String? message,
    int? code,
    OrderEntity? order,
    ShippingEntity? shipping,
  }) {
    return OrderDetailEntity(
      order: order ?? this.order,
      shipping: shipping ?? this.shipping,
    );
  }

  factory OrderDetailEntity.fromMap(Map<String, dynamic> map) {
    return OrderDetailEntity(
      order: OrderEntity.fromMap(map['orderDTO'] as Map<String, dynamic>),
      // order: OrderEntity.fromMap(
      //  ^!isList ? map['orderDTO'] as Map<String, dynamic> : map['orderDTOs'] as Map<String, dynamic>,
      // ),
      shipping: ShippingEntity.fromMap(map['shippingDTO'] as Map<String, dynamic>),
    );
  }

  factory OrderDetailEntity.fromJson(String source) => OrderDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      order,
      shipping,
    ];
  }

  @override
  bool get stringify => true;
}
