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
  final int shopId;
  final int? brandId;
  final int maxPrice;
  final int minPrice;
  final String rating;
  final int countProductVariant;
  final List<ProductVariantEntity> productVariants;

  const ProductEntity({
    required this.productId,
    required this.name,
    required this.image,
    required this.description,
    required this.information,
    required this.sold,
    required this.status,
    required this.categoryId,
    required this.shopId,
    this.brandId,
    required this.maxPrice,
    required this.minPrice,
    required this.rating,
    required this.countProductVariant,
    required this.productVariants,
  });

  static List<ProductEntity> fromList(List<dynamic> list) {
    return List<ProductEntity>.from(list.map((e) => ProductEntity.fromMap(e as Map<String, dynamic>)));
  }

  // get cheapest price of the product in the list of product variants
  int get cheapestPrice {
    return productVariants.map((e) => e.price).reduce((value, element) => value < element ? value : element);
  }

  // get the most expensive price of the product in the list of product variants
  int get mostExpensivePrice {
    return productVariants.map((e) => e.price).reduce((value, element) => value > element ? value : element);
  }

  ProductEntity copyWith({
    int? productId,
    String? name,
    String? image,
    String? description,
    String? information,
    int? sold,
    String? status,
    int? categoryId,
    int? shopId,
    int? brandId,
    int? maxPrice,
    int? minPrice,
    String? rating,
    int? countProductVariant,
    List<ProductVariantEntity>? productVariants,
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
      shopId: shopId ?? this.shopId,
      brandId: brandId ?? this.brandId,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      rating: rating ?? this.rating,
      countProductVariant: countProductVariant ?? this.countProductVariant,
      productVariants: productVariants ?? this.productVariants,
    );
  }

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
      'shopId': shopId,
      'brandId': brandId,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'rating': rating,
      'countProductVariant': countProductVariant,
      'productVariantDTOs': productVariants.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      productId: map['productId'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      information: map['information'] as String,
      sold: map['sold'] as int,
      status: map['status'] as String,
      categoryId: map['categoryId'] as int,
      shopId: map['shopId'] as int,
      brandId: map['brandId'] != null ? map['brandId'] as int : null,
      maxPrice: map['maxPrice'] as int,
      minPrice: map['minPrice'] as int,
      rating: map['rating'] as String,
      countProductVariant: map['countProductVariant'] as int,
      productVariants: List<ProductVariantEntity>.from(
        (map['productVariantDTOs'] as List<dynamic>).map<ProductVariantEntity>(
          (x) => ProductVariantEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductEntity.fromJson(String source) => ProductEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      productId,
      name,
      image,
      description,
      information,
      sold,
      status,
      categoryId,
      shopId,
      brandId,
      maxPrice,
      minPrice,
      rating,
      countProductVariant,
      productVariants,
    ];
  }
}
