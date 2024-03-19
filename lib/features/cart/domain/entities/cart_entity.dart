import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product_variant_entity.dart';

/// cartDTO
class CartEntity extends Equatable {
  final String cartId;
  final int quantity;
  final int productId;
  final String productName;
  final String? productImage;
  final DateTime? updateAt;
  final ProductVariantEntity productVariant;

  const CartEntity({
    required this.cartId,
    required this.quantity,
    required this.productId,
    required this.productName,
    this.productImage,
    this.updateAt,
    required this.productVariant,
  });

  factory CartEntity.fromMap(Map<String, dynamic> data) => CartEntity(
        cartId: data['cartId'] as String,
        quantity: data['quantity'] as int,
        productId: data['productId'] as int,
        productName: data['productName'] as String,
        productImage: data['productImage'] as String?,
        updateAt: data['updateAt'] == null
            ? null
            : DateTime.parse(data['updateAt'] as String),
        productVariant: ProductVariantEntity.fromMap(
            data['productVariantDTO'] as Map<String, dynamic>),
      );

  // Map<String, dynamic> toMap() => {
  //       'cartId': cartId,
  //       'quantity': quantity,
  //       'productId': productId,
  //       'productName': productName,
  //       'productImage': productImage,
  //       'updateAt': updateAt?.toIso8601String(),
  //       'productVariantDTO': productVariant.toMap(),
  //     };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CartEntity].
  factory CartEntity.fromJson(String data) {
    return CartEntity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  static List<CartEntity> fromJsonList(List<dynamic> listData) {
    return listData
        .map((e) => CartEntity.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// `dart:convert`
  ///
  /// Converts [CartEntity] to a JSON string.
  // String toJson() => json.encode(toMap());

  CartEntity copyWith({
    String? cartId,
    int? quantity,
    int? productId,
    String? productName,
    dynamic productImage,
    DateTime? updateAt,
    ProductVariantEntity? productVariant,
  }) {
    return CartEntity(
      cartId: cartId ?? this.cartId,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      updateAt: updateAt ?? this.updateAt,
      productVariant: productVariant ?? this.productVariant,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      cartId,
      quantity,
      productId,
      productName,
      productImage,
      updateAt,
      productVariant,
    ];
  }
}
