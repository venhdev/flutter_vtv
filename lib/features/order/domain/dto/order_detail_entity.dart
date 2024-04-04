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
  //> transport not implemented

  const OrderDetailEntity({
    required this.order,
    required this.shipping,
  });

  OrderDetailEntity copyWith({
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
      shipping: ShippingEntity.fromMap(map['shippingDTO'] as Map<String, dynamic>),
    );
  }

  factory OrderDetailEntity.fromJson(String source) =>
      OrderDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [order, shipping];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderDTO': order.toMap(),
      'shippingDTO': shipping.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
