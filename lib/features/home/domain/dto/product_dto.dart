// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../entities/product_entity.dart';

class ProductDTO {
  final int count;
  final int page;
  final int size;
  final int totalPage;
  List<ProductEntity> products;

  ProductDTO({
    required this.count,
    required this.page,
    required this.size,
    required this.totalPage,
    required this.products,
  });

  ProductDTO copyWith({
    int? count,
    int? page,
    int? size,
    int? totalPage,
    List<ProductEntity>? products,
  }) {
    return ProductDTO(
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      products: products ?? this.products,
    );
  }

  factory ProductDTO.fromMap(Map<String, dynamic> map) {
    return ProductDTO(
      count: map['count'] as int,
      page: map['page'] as int,
      size: map['size'] as int,
      totalPage: map['totalPage'] as int,
      products: ProductEntity.fromList(map['productDTOs'] as List<dynamic>),
    );
  }

  factory ProductDTO.fromJson(String source) => ProductDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ProductDTO other) {
    if (identical(this, other)) return true;

    return other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode ^ products.hashCode;
  }

  @override
  String toString() {
    return 'ProductDTO(count: $count, page: $page, size: $size, totalPage: $totalPage, products: $products)';
  }
}
