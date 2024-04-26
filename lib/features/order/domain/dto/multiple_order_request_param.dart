// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:vtv_common/order.dart';

typedef MultiOrderDetail = List<OrderDetailEntity>;

class MultipleOrderRequestParam extends Equatable {
  final List<OrderRequestWithCartParam> orderRequestWithCarts;

  const MultipleOrderRequestParam({
    required this.orderRequestWithCarts,
  });

  factory MultipleOrderRequestParam.fromOrderDetails(MultiOrderDetail orderDetails) {
    final orderRequestWithCarts = orderDetails.map((orderDetail) {
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

    return MultipleOrderRequestParam(
      orderRequestWithCarts: orderRequestWithCarts,
    );
  }

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

  @override
  List<Object> get props => [orderRequestWithCarts];

  MultipleOrderRequestParam copyWithIndex({
   required OrderRequestWithCartParam param,
   required int index,
  }) {
    final newOrderRequestWithCarts = List<OrderRequestWithCartParam>.from(orderRequestWithCarts);
    newOrderRequestWithCarts[index] = param;
    return MultipleOrderRequestParam(
      orderRequestWithCarts: newOrderRequestWithCarts,
    );
  }
}
