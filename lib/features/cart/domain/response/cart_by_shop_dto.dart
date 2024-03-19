import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../entities/cart_entity.dart';

// Carts of a shop
class CartByShopDTO extends Equatable {
  final int shopId;
  final String shopName;
  final String avatar;
  final List<CartEntity> carts;

  const CartByShopDTO({
    required this.shopId,
    required this.shopName,
    required this.avatar,
    required this.carts,
  });

  factory CartByShopDTO.fromMap(Map<String, dynamic> data) {
    return CartByShopDTO(
      shopId: data['shopId'] as int,
      shopName: data['shopName'] as String,
      avatar: data['avatar'] as String,
      carts: CartEntity.fromJsonList(data['carts'] as List<dynamic>),
    );
  }

  // Map<String, dynamic> toMap() => {
  //       'shopId': shopId,
  //       'shopName': shopName,
  //       'avatar': avatar,
  //       'carts': carts?.map((e) => e.toMap()).toList(),
  //     };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CartByShopDTO].
  factory CartByShopDTO.fromJson(String data) {
    return CartByShopDTO.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CartByShopDTO] to a JSON string.
  // String toJson() => json.encode(toMap());

  CartByShopDTO copyWith({
    int? shopId,
    String? shopName,
    String? avatar,
    List<CartEntity>? carts,
  }) {
    return CartByShopDTO(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      avatar: avatar ?? this.avatar,
      carts: carts ?? this.carts,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [shopId, shopName, avatar, carts];
}
