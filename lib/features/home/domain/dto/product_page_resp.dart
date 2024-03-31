import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../entities/product_entity.dart';

class ProductPageResp {
  final int count;
  final int page;
  final int size;
  final int totalPage;
  List<ProductEntity> products;

  ProductPageResp({
    required this.count,
    required this.page,
    required this.size,
    required this.totalPage,
    required this.products,
  });

  ProductPageResp copyWith({
    int? count,
    int? page,
    int? size,
    int? totalPage,
    List<ProductEntity>? products,
  }) {
    return ProductPageResp(
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      products: products ?? this.products,
    );
  }

  factory ProductPageResp.fromMap(Map<String, dynamic> map) {
    return ProductPageResp(
      count: map['count'] as int,
      page: map['page'] as int,
      size: map['size'] as int,
      totalPage: map['totalPage'] as int,
      products: ProductEntity.fromList(map['productDTOs'] as List<dynamic>),
    );
  }

  factory ProductPageResp.fromJson(String source) =>
      ProductPageResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ProductPageResp other) {
    if (identical(this, other)) return true;

    return other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return count.hashCode ^
        page.hashCode ^
        size.hashCode ^
        totalPage.hashCode ^
        products.hashCode;
  }

  @override
  String toString() {
    return 'ProductDTO(count: $count, page: $page, size: $size, totalPage: $totalPage, products: $products)';
  }
}
