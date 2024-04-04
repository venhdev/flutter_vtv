import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';
import '../../../profile/domain/entities/address_dto.dart';
import '../../../profile/domain/entities/loyalty_point_history_entity.dart';
import 'order_item_entity.dart';
import '../../../shop/domain/entities/shop_entity.dart';
import 'voucher_order_entity.dart';

class OrderEntity extends Equatable {
  final String? orderId; // --uuid
  final String? note;
  final String paymentMethod;
  final String shippingMethod;
  final int count;
  final int totalPrice;
  final int discountShop;
  final int discountSystem;
  final int shippingFee;
  final int paymentTotal;
  // final String status;
  final OrderStatus status;
  final DateTime orderDate;

  final LoyaltyPointHistoryEntity? loyaltyPointHistory;
  final AddressEntity address;
  final ShopEntity shop;
  final List<VoucherOrderEntity>? voucherOrders;
  final List<OrderItemEntity> orderItems;

  const OrderEntity({
    this.orderId,
    required this.note,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.count,
    required this.totalPrice,
    required this.discountShop,
    required this.discountSystem,
    required this.shippingFee,
    required this.paymentTotal,
    required this.status,
    required this.orderDate,
    this.loyaltyPointHistory,
    required this.address,
    required this.shop,
    this.voucherOrders,
    required this.orderItems,
  });

  Map<String, int> get getVariantIdsAndQuantityMap {
    final mapTemp = <String, int>{};
    for (final orderItem in orderItems) {
      mapTemp[orderItem.productVariant.productVariantId.toString()] = orderItem.quantity;
    }
    return mapTemp;
  }

  OrderEntity copyWith({
    String? orderId,
    String? note,
    String? paymentMethod,
    String? shippingMethod,
    int? count,
    int? totalPrice,
    int? discountShop,
    int? discountSystem,
    int? shippingFee,
    int? paymentTotal,
    OrderStatus? status,
    DateTime? orderDate,
    LoyaltyPointHistoryEntity? loyaltyPointHistory,
    AddressEntity? address,
    ShopEntity? shop,
    List<VoucherOrderEntity>? voucherOrders,
    List<OrderItemEntity>? orderItems,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      count: count ?? this.count,
      totalPrice: totalPrice ?? this.totalPrice,
      discountShop: discountShop ?? this.discountShop,
      discountSystem: discountSystem ?? this.discountSystem,
      shippingFee: shippingFee ?? this.shippingFee,
      paymentTotal: paymentTotal ?? this.paymentTotal,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      loyaltyPointHistory: loyaltyPointHistory ?? this.loyaltyPointHistory,
      address: address ?? this.address,
      shop: shop ?? this.shop,
      voucherOrders: voucherOrders ?? this.voucherOrders,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'note': note,
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      'count': count,
      'totalPrice': totalPrice,
      'discountShop': discountShop,
      'discountSystem': discountSystem,
      'shippingFee': shippingFee,
      'paymentTotal': paymentTotal,
      'status': status.name,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'loyaltyPointHistoryDTO': loyaltyPointHistory?.toMap(),
      'addressDTO': address.toMap(),
      'shopDTO': shop.toMap(),
      'voucherOrderDTOs': voucherOrders?.map((x) => x.toMap()).toList(),
      'orderItemDTOs': orderItems.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      note: map['note'] as String?,
      paymentMethod: map['paymentMethod'] as String,
      shippingMethod: map['shippingMethod'] as String,
      count: map['count'] as int,
      totalPrice: map['totalPrice'] as int,
      discountShop: map['discountShop'] as int,
      discountSystem: map['discountSystem'] as int,
      shippingFee: map['shippingFee'] as int,
      paymentTotal: map['paymentTotal'] as int,
      // status: map['status'] as String,
      status: OrderStatus.values.firstWhere((e) => e.name == map['status'] as String),
      orderDate: DateTime.parse(map['orderDate'] as String),
      loyaltyPointHistory: map['loyaltyPointHistoryDTO'] != null
          ? LoyaltyPointHistoryEntity.fromMap(map['loyaltyPointHistoryDTO'] as Map<String, dynamic>)
          : null,
      address: AddressEntity.fromMap(map['addressDTO'] as Map<String, dynamic>),
      shop: ShopEntity.fromMap(map['shopDTO'] as Map<String, dynamic>),
      voucherOrders: map['voucherOrderDTOs'] != null
          ? List<VoucherOrderEntity>.from(
              (map['voucherOrderDTOs'] as List<dynamic>).map<VoucherOrderEntity>(
                (x) => VoucherOrderEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      orderItems: List<OrderItemEntity>.from(
        (map['orderItemDTOs'] as List<dynamic>).map<OrderItemEntity>(
          (x) => OrderItemEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderEntity.fromJson(String source) => OrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);
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
      totalPrice,
      discountShop,
      discountSystem,
      shippingFee,
      paymentTotal,
      status,
      orderDate,
      loyaltyPointHistory,
      address,
      shop,
      voucherOrders,
      orderItems,
    ];
  }
}
