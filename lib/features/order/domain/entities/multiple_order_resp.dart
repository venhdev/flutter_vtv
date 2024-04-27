import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:vtv_common/order.dart';

class MultipleOrderResp extends Equatable {
  final int count; //
  final int totalProduct; //
  final int totalQuantity;
  final int totalPrice;
  final int totalPayment;
  final int totalDiscount; //
  final int totalShippingFee;
  final int totalLoyaltyPoint;
  final int discountShop;
  final int discountSystem;
  final List<OrderDetailEntity> orderDetails; //MultiOrderDetail

  const MultipleOrderResp({
    required this.count,
    required this.totalProduct,
    required this.totalQuantity,
    required this.totalPrice,
    required this.totalPayment,
    required this.totalDiscount,
    required this.totalShippingFee,
    required this.totalLoyaltyPoint,
    required this.discountShop,
    required this.discountSystem,
    required this.orderDetails,
  });

  @override
  List<Object> get props {
    return [
      count,
      totalProduct,
      totalQuantity,
      totalPrice,
      totalPayment,
      totalDiscount,
      totalShippingFee,
      totalLoyaltyPoint,
      discountShop,
      discountSystem,
      orderDetails,
    ];
  }

  MultipleOrderResp copyWith({
    int? count,
    int? totalProduct,
    int? totalQuantity,
    int? totalPrice,
    int? totalPayment,
    int? totalDiscount,
    int? totalShippingFee,
    int? totalLoyaltyPoint,
    int? discountShop,
    int? discountSystem,
    List<OrderDetailEntity>? orderDetails,
  }) {
    return MultipleOrderResp(
      count: count ?? this.count,
      totalProduct: totalProduct ?? this.totalProduct,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
      totalPayment: totalPayment ?? this.totalPayment,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalShippingFee: totalShippingFee ?? this.totalShippingFee,
      totalLoyaltyPoint: totalLoyaltyPoint ?? this.totalLoyaltyPoint,
      discountShop: discountShop ?? this.discountShop,
      discountSystem: discountSystem ?? this.discountSystem,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'totalProduct': totalProduct,
      'totalQuantity': totalQuantity,
      'totalPrice': totalPrice,
      'totalPayment': totalPayment,
      'totalDiscount': totalDiscount,
      'totalShippingFee': totalShippingFee,
      'totalLoyaltyPoint': totalLoyaltyPoint,
      'discountShop': discountShop,
      'discountSystem': discountSystem,
      'orderDetails': orderDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory MultipleOrderResp.fromMap(Map<String, dynamic> map) {
    return MultipleOrderResp(
      count: map['count'] as int,
      totalProduct: map['totalProduct'] as int,
      totalQuantity: map['totalQuantity'] as int,
      totalPrice: map['totalPrice'] as int,
      totalPayment: map['totalPayment'] as int,
      totalDiscount: map['totalDiscount'] as int,
      totalShippingFee: map['totalShippingFee'] as int,
      totalLoyaltyPoint: map['totalLoyaltyPoint'] as int,
      discountShop: map['discountShop'] as int,
      discountSystem: map['discountSystem'] as int,
      orderDetails: List<OrderDetailEntity>.from(
        (map['orderResponses'] as List)
            .map<OrderDetailEntity>((x) => OrderDetailEntity.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MultipleOrderResp.fromJson(String source) =>
      MultipleOrderResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
