import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product_variant_entity.dart';

class OrderItemEntity extends Equatable {
  final String? orderItemId;
  final String? orderId;
  final String? cartId;
  final int quantity;
  final int price;
  final int totalPrice;
  final ProductVariantEntity productVariant;

  const OrderItemEntity({
    this.orderItemId,
    this.orderId,
    required this.cartId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.productVariant,
  });

  OrderItemEntity copyWith({
    String? orderItemId,
    String? orderId,
    String? cartId,
    int? quantity,
    int? price,
    int? totalPrice,
    ProductVariantEntity? productVariant,
  }) {
    return OrderItemEntity(
      orderItemId: orderItemId ?? this.orderItemId,
      orderId: orderId ?? this.orderId,
      cartId: cartId ?? this.cartId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      productVariant: productVariant ?? this.productVariant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemId': orderItemId,
      'orderId': orderId,
      'cartId': cartId,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'productVariant': productVariant.toMap(),
    };
  }

  factory OrderItemEntity.fromMap(Map<String, dynamic> map) {
    return OrderItemEntity(
      orderItemId: map['orderItemId'] != null ? map['orderItemId'] as String : null,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      cartId: map['cartId'] as String?,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
      totalPrice: map['totalPrice'] as int,
      productVariant: ProductVariantEntity.fromMap(map['productVariantDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemEntity.fromJson(String source) =>
      OrderItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      orderItemId,
      orderId,
      cartId,
      quantity,
      price,
      totalPrice,
      productVariant,
    ];
  }
}
