// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'attribute_entity.dart';

class ProductVariantEntity extends Equatable {
  final int productVariantId;
  final String sku;
  final String image;
  final int? originalPrice;
  final int price;
  final int quantity;
  final String status;
  final int productId;
  final String productName;
  final String productImage;
  final List<AttributeEntity> attributes;

  const ProductVariantEntity({
    required this.productVariantId,
    required this.sku,
    required this.image,
    required this.originalPrice,
    required this.price,
    required this.quantity,
    required this.status,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.attributes,
  });

  ProductVariantEntity copyWith({
    int? productVariantId,
    String? sku,
    String? image,
    int? originalPrice,
    int? price,
    int? quantity,
    String? status,
    int? productId,
    String? productName,
    String? productImage,
    List<AttributeEntity>? attributes,
  }) {
    return ProductVariantEntity(
      productVariantId: productVariantId ?? this.productVariantId,
      sku: sku ?? this.sku,
      image: image ?? this.image,
      originalPrice: originalPrice ?? this.originalPrice, // nullable
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      attributes: attributes ?? this.attributes,
    );
  }

  factory ProductVariantEntity.fromMap(Map<String, dynamic> map) {
    return ProductVariantEntity(
      productVariantId: map['productVariantId'].toInt() as int,
      sku: map['sku'] as String,
      image: map['image'] as String,
      originalPrice: map['originalPrice']?.toInt() as int?,
      price: map['price'].toInt() as int,
      quantity: map['quantity'].toInt() as int,
      status: map['status'] as String,
      productId: map['productId'].toInt() as int,
      productName: map['productName'] as String,
      productImage: map['productImage'] as String,
      attributes: AttributeEntity.fromList(map['attributeDTOs'] as List<dynamic>),
    );
  }

  static List<ProductVariantEntity> fromList(List<dynamic> map) {
    return List<ProductVariantEntity>.from(
      map.map<ProductVariantEntity>(
        (x) => ProductVariantEntity.fromMap(x),
      ),
    );
  }

  factory ProductVariantEntity.fromJson(String source) =>
      ProductVariantEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductVariantEntity(productVariantId: $productVariantId, sku: $sku, image: $image, originalPrice: $originalPrice, price: $price, quantity: $quantity, status: $status, productId: $productId, productName: $productName, productImage: $productImage, attributeDTOs: $attributes)';
  }

  @override
  List<Object?> get props => [
        productVariantId,
        sku,
        image,
        originalPrice,
        price,
        quantity,
        status,
        productId,
        productName,
        productImage,
        attributes,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productVariantId': productVariantId,
      'sku': sku,
      'image': image,
      'originalPrice': originalPrice,
      'price': price,
      'quantity': quantity,
      'status': status,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'attributes': attributes.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
