import 'dart:convert';

import 'package:equatable/equatable.dart';

class PlaceOrderParam extends Equatable {
  final int addressId;
  final String? systemVoucherCode;
  final String? shopVoucherCode;
  final bool? useLoyaltyPoint;
  final String paymentMethod;
  final String shippingMethod;
  final String note;
  final List<String> cartIds;

  const PlaceOrderParam({
    required this.addressId,
    this.systemVoucherCode,
    this.shopVoucherCode,
    this.useLoyaltyPoint,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.note,
    required this.cartIds,
  });

  PlaceOrderParam copyWith({
    int? addressId,
    String? systemVoucherCode,
    String? shopVoucherCode,
    bool? useLoyaltyPoint,
    String? paymentMethod,
    String? shippingMethod,
    String? note,
    List<String>? cartIds,
  }) {
    return PlaceOrderParam(
      addressId: addressId ?? this.addressId,
      systemVoucherCode: systemVoucherCode ?? this.systemVoucherCode,
      shopVoucherCode: shopVoucherCode ?? this.shopVoucherCode,
      useLoyaltyPoint: useLoyaltyPoint ?? this.useLoyaltyPoint,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      note: note ?? this.note,
      cartIds: cartIds ?? this.cartIds,
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
      'cartIds': cartIds,
    };
  }

  factory PlaceOrderParam.fromMap(Map<String, dynamic> map) {
    return PlaceOrderParam(
      addressId: map['addressId'] as int,
      systemVoucherCode: map['systemVoucherCode'] != null ? map['systemVoucherCode'] as String : null,
      shopVoucherCode: map['shopVoucherCode'] != null ? map['shopVoucherCode'] as String : null,
      useLoyaltyPoint: map['useLoyaltyPoint'] != null ? map['useLoyaltyPoint'] as bool? : null,
      paymentMethod: map['paymentMethod'] as String,
      shippingMethod: map['shippingMethod'] as String,
      note: map['note'] as String,
      cartIds: List<String>.from((map['cartIds'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceOrderParam.fromJson(String source) =>
      PlaceOrderParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

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
      cartIds,
    ];
  }
}
