import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/base/base_lazy_load_entity.dart';
import '../entities/product_entity.dart';

class ProductPageResp extends IBasePageResp<ProductEntity> {
  const ProductPageResp({
    required super.count,
    required super.page,
    required super.size,
    required super.totalPage,
    required super.listItem,
  });

  ProductPageResp copyWith({
    int? count,
    int? page,
    int? size,
    int? totalPage,
    List<ProductEntity>? listItem,
  }) {
    return ProductPageResp(
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      listItem: listItem ?? this.listItem,
    );
  }

  factory ProductPageResp.fromMap(Map<String, dynamic> map) {
    return ProductPageResp(
      count: map['count'] as int,
      page: map['page'] as int,
      size: map['size'] as int,
      totalPage: map['totalPage'] as int,
      listItem: ProductEntity.fromList(map['productDTOs'] as List<dynamic>),
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
        listEquals(other.listItem, listItem);
  }

  @override
  int get hashCode {
    return count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode ^ listItem.hashCode;
  }

  @override
  String toString() {
    return 'ProductDTO(count: $count, page: $page, size: $size, totalPage: $totalPage, listItem: $listItem)';
  }
}
