import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'cart_by_shop_dto.dart';

class CartResp extends Equatable {
  // final String username;
  final int count;
  final List<CartByShopDTO> cartByShopDTOs;

  const CartResp({
    // required this.username,
    required this.count,
    required this.cartByShopDTOs,
  });

  factory CartResp.fromMap(Map<String, dynamic> data) => CartResp(
        // username: data['username'] as String,
        count: data['count'] as int,
        cartByShopDTOs: (data['listCartByShopDTOs'] as List<dynamic>)
            .map(
              (e) => CartByShopDTO.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
      );

  // Map<String, dynamic> toMap() => {
  //       'username': username,
  //       'count': count,
  //       'listCartByShopDTOs': listCartByShopDtOs?.map((e) => e.toMap()).toList(),
  //     };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CartResp].
  factory CartResp.fromJson(String data) {
    return CartResp.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Cart] to a JSON string.
  // String toJson() => json.encode(toMap());

  CartResp copyWith({
    String? username,
    int? count,
    List<CartByShopDTO>? cartByShopDTOs,
  }) {
    return CartResp(
      // username: username ?? this.username,
      count: count ?? this.count,
      cartByShopDTOs: cartByShopDTOs ?? this.cartByShopDTOs,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      // username,
      count,
      cartByShopDTOs,
    ];
  }
}
