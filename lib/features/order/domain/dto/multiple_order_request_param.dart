import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

class MultipleOrderRequestParam {
  final List<OrderRequestWithCartParam> orderRequestWithCarts;

  MultipleOrderRequestParam._({
    required this.orderRequestWithCarts,
    String? systemVoucherCode,
    int? loyaltyPointIndex,
    required PaymentTypes paymentMethod,
  })  : _systemVoucherCode = systemVoucherCode,
        _loyaltyPointIndex = loyaltyPointIndex,
        _paymentMethod = paymentMethod;

  factory MultipleOrderRequestParam.fromOrderDetails(MultipleOrderResp multipleOrderResp) {
    final orderRequestWithCarts = multipleOrderResp.orderDetails.map((orderDetail) {
      return OrderRequestWithCartParam(
        addressId: orderDetail.order.address.addressId,
        cartIds: orderDetail.order.orderItems.map((orderItem) => orderItem.cartId).toList(),
        systemVoucherCode: null,
        shopVoucherCode: null,
        paymentMethod: orderDetail.order.paymentMethod,
        shippingMethod: orderDetail.order.shippingMethod,
        note: '',
        useLoyaltyPoint: false,
      );
    }).toList();

    return MultipleOrderRequestParam._(
      orderRequestWithCarts: orderRequestWithCarts,
      systemVoucherCode: null,
      loyaltyPointIndex: null,
      paymentMethod: multipleOrderResp.orderDetails.first.order.paymentMethod,
    );
  }

  // control payment method
  PaymentTypes _paymentMethod;
  PaymentTypes get paymentMethod => _paymentMethod;
  set paymentMethod(PaymentTypes method) {
    _paymentMethod = method;
    for (var i = 0; i < orderRequestWithCarts.length; i++) {
      orderRequestWithCarts[i] = orderRequestWithCarts[i].copyWith(paymentMethod: method);
    }
  }

  // control systemVoucherCode
  String? _systemVoucherCode;
  String? get systemVoucherCode => _systemVoucherCode;
  set systemVoucherCode(String? value) {
    if (value == null) {
      _systemVoucherCode = null;
      for (var i = 0; i < orderRequestWithCarts.length; i++) {
        orderRequestWithCarts[i] = orderRequestWithCarts[i].copyWith(systemVoucherCode: null);
      }
    } else {
      _systemVoucherCode = value;
      for (var i = 0; i < orderRequestWithCarts.length; i++) {
        orderRequestWithCarts[i] = orderRequestWithCarts[i].copyWith(systemVoucherCode: value);
      }
    }
  }

  // control address
  int get addressId => orderRequestWithCarts.first.addressId;
  void setAddressId(int addressId) {
    for (var i = 0; i < orderRequestWithCarts.length; i++) {
      orderRequestWithCarts[i] = orderRequestWithCarts[i].copyWith(addressId: addressId);
    }
  }

  // control useLoyaltyPoint
  int? _loyaltyPointIndex;
  int? get loyaltyPointIndex => _loyaltyPointIndex; // null means not use loyalty point
  void setUseLoyaltyPoint(bool value, int index) {
    // set use loyalty point for only one orderRequestWithCarts, other will be false
    for (var i = 0; i < orderRequestWithCarts.length; i++) {
      orderRequestWithCarts[i] = orderRequestWithCarts[i].copyWith(useLoyaltyPoint: i == index ? value : false);
    }
    _loyaltyPointIndex = value ? index : null;
  }

  // check exist system voucher code
  bool get hasSystemVoucherCode => orderRequestWithCarts.any((element) => element.systemVoucherCode != null);
  // check use loyalty point
  bool get useLoyaltyPoint => orderRequestWithCarts.any((element) => element.useLoyaltyPoint);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderRequestWithCarts': orderRequestWithCarts.map((x) => x.toMap()).toList(),
    };
  }

  // factory MultipleOrderRequestParam.fromMap(Map<String, dynamic> map) {
  //   return MultipleOrderRequestParam(
  //     orderRequestWithCarts: List<OrderRequestWithCartParam>.from(
  //       (map['orderRequestWithCarts'] as List<int>).map<OrderRequestWithCartParam>(
  //         (x) => OrderRequestWithCartParam.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory MultipleOrderRequestParam.fromJson(String source) =>
  //     MultipleOrderRequestParam.fromMap(json.decode(source) as Map<String, dynamic>);

  MultipleOrderRequestParam copyWithIndex({
    required OrderRequestWithCartParam param,
    required int index,
  }) {
    final newOrderRequestWithCarts = List<OrderRequestWithCartParam>.from(orderRequestWithCarts);
    newOrderRequestWithCarts[index] = param;
    return MultipleOrderRequestParam._(
      orderRequestWithCarts: newOrderRequestWithCarts,
      systemVoucherCode: systemVoucherCode, // copy old value
      loyaltyPointIndex: loyaltyPointIndex, // copy old value
      paymentMethod: paymentMethod, // copy old value
    );
  }

  void changeNote({
    required int index,
    required String note,
  }) {
    orderRequestWithCarts[index].note = note;
  }

  @override
  bool operator ==(covariant MultipleOrderRequestParam other) {
    if (identical(this, other)) return true;

    return listEquals(other.orderRequestWithCarts, orderRequestWithCarts) &&
        other.systemVoucherCode == systemVoucherCode;
  }

  @override
  int get hashCode => orderRequestWithCarts.hashCode ^ systemVoucherCode.hashCode;
}
