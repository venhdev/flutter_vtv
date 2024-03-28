import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'cart_entity.dart';

// Carts of a shop
class CartByShopEntity extends Equatable {
  final int shopId;
  final String shopName;
  final String avatar;
  final List<CartEntity> carts;

  const CartByShopEntity({
    required this.shopId,
    required this.shopName,
    required this.avatar,
    required this.carts,
  });

  factory CartByShopEntity.fromMap(Map<String, dynamic> data) {
    return CartByShopEntity(
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
  /// Parses the string and returns the resulting Json object as [CartByShopEntity].
  factory CartByShopEntity.fromJson(String data) {
    return CartByShopEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CartByShopEntity] to a JSON string.
  // String toJson() => json.encode(toMap());

  CartByShopEntity copyWith({
    int? shopId,
    String? shopName,
    String? avatar,
    List<CartEntity>? carts,
  }) {
    return CartByShopEntity(
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
