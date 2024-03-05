// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'product_variant_entity.dart';

class ProductEntity extends Equatable {
  final int productId;
  final String name;
  final String image;
  final String description;
  final String information;
  final int sold;
  final String status;
  final int categoryId;
  final int? brandId;
  final List<ProductVariantEntity> productVariant;

  const ProductEntity({
    required this.productId,
    required this.name,
    required this.image,
    required this.description,
    required this.information,
    required this.sold,
    required this.status,
    required this.categoryId,
    required this.brandId,
    required this.productVariant,
  });

  ProductEntity copyWith({
    int? productId,
    String? name,
    String? image,
    String? description,
    String? information,
    int? sold,
    String? status,
    int? categoryId,
    int? brandId,
    List<ProductVariantEntity>? productVariant,
  }) {
    return ProductEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      information: information ?? this.information,
      sold: sold ?? this.sold,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      productVariant: productVariant ?? this.productVariant,
    );
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      productId: map['productId'].toInt() as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      information: map['information'] as String,
      sold: map['sold'].toInt() as int,
      status: map['status'] as String,
      categoryId: map['categoryId'].toInt() as int,
      brandId: map['brandId']?.toInt() as int?,
      productVariant: ProductVariantEntity.fromList(map['productVariantDTOs'] as List<dynamic>),
    );
  }

  factory ProductEntity.fromJson(String source) => ProductEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<ProductEntity> fromList(List<dynamic> list) {
    return List<ProductEntity>.from(list.map((e) => ProductEntity.fromMap(e as Map<String, dynamic>)));
  }

  @override
  String toString() {
    return 'ProductEntity(productId: $productId, name: $name, image: $image, description: $description, information: $information, sold: $sold, status: $status, categoryId: $categoryId, brandId: $brandId, productVariantDTOs: $productVariant)';
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        image,
        description,
        information,
        sold,
        status,
        categoryId,
        brandId,
        productVariant,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      'image': image,
      'description': description,
      'information': information,
      'sold': sold,
      'status': status,
      'categoryId': categoryId,
      'brandId': brandId,
      'productVariant': productVariant.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
