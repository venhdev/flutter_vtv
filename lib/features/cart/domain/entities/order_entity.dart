import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../profile/domain/entities/address_dto.dart';
import 'order_item_entity.dart';
import 'voucher_order_entity.dart';

class OrderEntity extends Equatable {
  final String? orderId;
  final String? note;
  final String paymentMethod;
  final String shippingMethod;
  final int count;
  final int shopId;
  final String shopName;
  final int totalPrice;
  final int discountShop;
  final int discountSystem;
  final int shippingFee;
  final int paymentTotal;
  final String shopWardCode;
  final String status;
  final DateTime orderDate;
  final AddressEntity address;
  final VoucherOrderEntity? voucherOrders;
  final List<OrderItemEntity> orderItems;

  const OrderEntity({
    this.orderId,
    this.note,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.count,
    required this.shopId,
    required this.shopName,
    required this.totalPrice,
    required this.discountShop,
    required this.discountSystem,
    required this.shippingFee,
    required this.paymentTotal,
    required this.shopWardCode,
    required this.status,
    required this.orderDate,
    required this.address,
    required this.voucherOrders,
    required this.orderItems,
  });

  OrderEntity copyWith({
    String? orderId,
    String? note,
    String? paymentMethod,
    String? shippingMethod,
    int? count,
    int? shopId,
    String? shopName,
    int? totalPrice,
    int? discountShop,
    int? discountSystem,
    int? shippingFee,
    int? paymentTotal,
    String? shopWardCode,
    String? status,
    DateTime? orderDate,
    AddressEntity? address,
    VoucherOrderEntity? voucherOrders,
    List<OrderItemEntity>? orderItems,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      count: count ?? this.count,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      totalPrice: totalPrice ?? this.totalPrice,
      discountShop: discountShop ?? this.discountShop,
      discountSystem: discountSystem ?? this.discountSystem,
      shippingFee: shippingFee ?? this.shippingFee,
      paymentTotal: paymentTotal ?? this.paymentTotal,
      shopWardCode: shopWardCode ?? this.shopWardCode,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      address: address ?? this.address,
      voucherOrders: voucherOrders ?? this.voucherOrders,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'orderId': orderId,
  //     'note': note,
  //     'paymentMethod': paymentMethod,
  //     'shippingMethod': shippingMethod,
  //     'count': count,
  //     'shopId': shopId,
  //     'shopName': shopName,
  //     'totalPrice': totalPrice,
  //     'discountShop': discountShop,
  //     'discountSystem': discountSystem,
  //     'shippingFee': shippingFee,
  //     'paymentTotal': paymentTotal,
  //     'shopWardCode': shopWardCode,
  //     'status': status,
  //     'orderDate': orderDate.millisecondsSinceEpoch,
  //     'addressDto': address.toMap(),
  //     'voucherOrderDtOs': voucherOrders,
  //     'orderItemDtOs': orderItems.map((x) => x.toMap()).toList(),
  //   };
  // }

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      paymentMethod: map['paymentMethod'] as String,
      shippingMethod: map['shippingMethod'] as String,
      count: map['count'] as int,
      shopId: map['shopId'] as int,
      shopName: map['shopName'] as String,
      totalPrice: map['totalPrice'] as int,
      discountShop: map['discountShop'] as int,
      discountSystem: map['discountSystem'] as int,
      shippingFee: map['shippingFee'] as int,
      paymentTotal: map['paymentTotal'] as int,
      shopWardCode: map['shopWardCode'] as String,
      status: map['status'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
      address: AddressEntity.fromMap(map['addressDTO'] as Map<String, dynamic>),
      voucherOrders: map['voucherOrderDTOs'] as dynamic,
      orderItems: List<OrderItemEntity>.from(
        (map['orderItemDTOs'] as List<dynamic>).map<OrderItemEntity>(
          (x) => OrderItemEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  // String toJson() => json.encode(toMap());

  factory OrderEntity.fromJson(String source) =>
      OrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
  @override
  List<Object?> get props {
    return [
      orderId,
      note,
      paymentMethod,
      shippingMethod,
      count,
      shopId,
      shopName,
      totalPrice,
      discountShop,
      discountSystem,
      shippingFee,
      paymentTotal,
      shopWardCode,
      status,
      orderDate,
      address,
      voucherOrders,
      orderItems,
    ];
  }
}
