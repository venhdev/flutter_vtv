import 'dart:convert';

import 'package:equatable/equatable.dart';

class PlaceOrderWithVariantParam extends Equatable {
  final int addressId;
  final String? systemVoucherCode;
  final String? shopVoucherCode;
  final bool? useLoyaltyPoint;
  final String paymentMethod;
  final String shippingMethod;
  final String note;
  final Map<String, int> variantIds; // key: variantId, value: quantity

  const PlaceOrderWithVariantParam({
    required this.addressId,
    this.systemVoucherCode,
    this.shopVoucherCode,
    this.useLoyaltyPoint,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.note,
    required this.variantIds,
  });

  @override
  List<Object?> get props {
    return [
      addressId,
      systemVoucherCode,
      shopVoucherCode,
      useLoyaltyPoint,
      paymentMethod,
      shippingMethod,
      note,
      variantIds,
    ];
  }

  PlaceOrderWithVariantParam copyWith({
    int? addressId,
    String? systemVoucherCode,
    String? shopVoucherCode,
    bool? useLoyaltyPoint,
    String? paymentMethod,
    String? shippingMethod,
    String? note,
    Map<String, int>? variantIds,
  }) {
    return PlaceOrderWithVariantParam(
      addressId: addressId ?? this.addressId,
      systemVoucherCode: systemVoucherCode ?? this.systemVoucherCode,
      shopVoucherCode: shopVoucherCode ?? this.shopVoucherCode,
      useLoyaltyPoint: useLoyaltyPoint ?? this.useLoyaltyPoint,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      note: note ?? this.note,
      variantIds: variantIds ?? this.variantIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressId': addressId,
      'systemVoucherCode': systemVoucherCode,
      'shopVoucherCode': shopVoucherCode,
      'useLoyaltyPoint': useLoyaltyPoint,
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      'note': note,
      'productVariantIdsAndQuantities': variantIds,
    };
  }

  factory PlaceOrderWithVariantParam.fromMap(Map<String, dynamic> map) {
    return PlaceOrderWithVariantParam(
      addressId: map['addressId'] as int,
      systemVoucherCode: map['systemVoucherCode'] != null ? map['systemVoucherCode'] as String : null,
      shopVoucherCode: map['shopVoucherCode'] != null ? map['shopVoucherCode'] as String : null,
      useLoyaltyPoint: map['useLoyaltyPoint'] != null ? map['useLoyaltyPoint'] as bool : null,
      paymentMethod: map['paymentMethod'] as String,
      shippingMethod: map['shippingMethod'] as String,
      note: map['note'] as String,
      variantIds: Map<String, int>.from(
        (map['variantIds'] as Map<String, int>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceOrderWithVariantParam.fromJson(String source) =>
      PlaceOrderWithVariantParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
