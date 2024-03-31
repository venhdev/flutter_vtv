//? GET /api/product/detail/{productId}

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../entities/product_entity.dart';

class ProductDetailResp extends Equatable {
  final String status;
  final String message;
  final int code;
  final int categoryId;
  final String categoryName;
  final int categoryParentId;
  final String categoryParentName;
  final int shopId;
  final String shopName;
  final String shopAvatar;
  final int countOrder;
  final ProductEntity product;

  const ProductDetailResp({
    required this.status,
    required this.message,
    required this.code,
    required this.categoryId,
    required this.categoryName,
    required this.categoryParentId,
    required this.categoryParentName,
    required this.shopId,
    required this.shopName,
    required this.shopAvatar,
    required this.countOrder,
    required this.product,
  });

  @override
  List<Object> get props {
    return [
      status,
      message,
      code,
      categoryId,
      categoryName,
      categoryParentId,
      categoryParentName,
      shopId,
      shopName,
      shopAvatar,
      countOrder,
      product,
    ];
  }

  ProductDetailResp copyWith({
    String? status,
    String? message,
    int? code,
    int? categoryId,
    String? categoryName,
    int? categoryParentId,
    String? categoryParentName,
    int? shopId,
    String? shopName,
    String? shopAvatar,
    int? countOrder,
    ProductEntity? product,
  }) {
    return ProductDetailResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryParentId: categoryParentId ?? this.categoryParentId,
      categoryParentName: categoryParentName ?? this.categoryParentName,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAvatar: shopAvatar ?? this.shopAvatar,
      countOrder: countOrder ?? this.countOrder,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'code': code,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryParentId': categoryParentId,
      'categoryParentName': categoryParentName,
      'shopId': shopId,
      'shopName': shopName,
      'shopAvatar': shopAvatar,
      'countOrder': countOrder,
      'productDTO': product.toMap(),
    };
  }

  factory ProductDetailResp.fromMap(Map<String, dynamic> map) {
    return ProductDetailResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      categoryId: map['categoryId'] as int,
      categoryName: map['categoryName'] as String,
      categoryParentId: map['categoryParentId'] as int,
      categoryParentName: map['categoryParentName'] as String,
      shopId: map['shopId'] as int,
      shopName: map['shopName'] as String,
      shopAvatar: map['shopAvatar'] as String,
      countOrder: map['countOrder'] as int,
      product: ProductEntity.fromMap(map['productDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetailResp.fromJson(String source) =>
      ProductDetailResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
