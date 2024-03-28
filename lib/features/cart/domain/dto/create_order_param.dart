// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CreateOrderParam extends Equatable {
  final int addressId;
  final String systemVoucherCode;
  final String paymentMethod;
  final String shippingMethod;
  final String note;
  final List<String> cartIds;

  const CreateOrderParam({
    required this.addressId,
    required this.systemVoucherCode,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.note,
    required this.cartIds,
  });

  // add cartId method
  void addCartId(String cartId) {
    cartIds.add(cartId);
  }

  CreateOrderParam copyWith({
    int? addressId,
    String? systemVoucherCode,
    String? paymentMethod,
    String? shippingMethod,
    String? note,
    List<String>? cartIds,
  }) {
    return CreateOrderParam(
      addressId: addressId ?? this.addressId,
      systemVoucherCode: systemVoucherCode ?? this.systemVoucherCode,
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
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      'note': note,
      'cartIds': cartIds,
    };
  }

  factory CreateOrderParam.fromMap(Map<String, dynamic> map) {
    return CreateOrderParam(
      addressId: map['addressId'] as int,
      systemVoucherCode: map['systemVoucherCode'] as String,
      paymentMethod: map['paymentMethod'] as String,
      shippingMethod: map['shippingMethod'] as String,
      note: map['note'] as String,
      cartIds: List<String>.from((map['cartIds'] as List<String>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory CreateOrderParam.fromJson(String source) => CreateOrderParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      addressId,
      systemVoucherCode,
      paymentMethod,
      shippingMethod,
      note,
      cartIds,
    ];
  }
}
