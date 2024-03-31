// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/entities/shipping_entity.dart';

//! OrderResp with one OrderEntity
//! OrdersResp with List<OrderEntity>
class OrderResp extends Equatable {
  final String status;
  final String message;
  final int code;
  final OrderEntity order;
  final ShippingEntity shipping;

  const OrderResp({
    required this.status,
    required this.message,
    required this.code,
    required this.order,
    required this.shipping,
  });

  OrderResp copyWith({
    String? status,
    String? message,
    int? code,
    OrderEntity? order,
    ShippingEntity? shipping,
  }) {
    return OrderResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      order: order ?? this.order,
      shipping: shipping ?? this.shipping,
    );
  }

  factory OrderResp.fromMap(Map<String, dynamic> map) {
    return OrderResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      order: OrderEntity.fromMap(map['orderDTO'] as Map<String, dynamic>),
      // order: OrderEntity.fromMap(
      //  ^!isList ? map['orderDTO'] as Map<String, dynamic> : map['orderDTOs'] as Map<String, dynamic>,
      // ),
      shipping: ShippingEntity.fromMap(map['shippingDTO'] as Map<String, dynamic>),
    );
  }

  factory OrderResp.fromJson(String source) => OrderResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      status,
      message,
      code,
      order,
      shipping,
    ];
  }

  @override
  bool get stringify => true;
}

class OrdersResp extends Equatable {
  final String status;
  final String message;
  final int code;
  final List<OrderEntity> orders;
  // final ShippingEntity shipping;

  const OrdersResp({
    required this.status,
    required this.message,
    required this.code,
    required this.orders,
    // required this.shipping,
  });

  OrdersResp copyWith({
    String? status,
    String? message,
    int? code,
    List<OrderEntity>? orders,
  }) {
    return OrdersResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      orders: orders ?? this.orders,
      // shipping: shipping ?? this.shipping,
    );
  }

  factory OrdersResp.fromMap(Map<String, dynamic> map) {
    return OrdersResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      orders: (map['orderDTOs'] as List<dynamic>)
          .map(
            (e) => OrderEntity.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  factory OrdersResp.fromJson(String source) => OrdersResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      status,
      message,
      code,
      orders,
      // shipping,
    ];
  }

  @override
  bool get stringify => true;
}
