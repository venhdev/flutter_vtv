// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FavoriteProductEntity extends Equatable {
  final int favoriteProductId;
  final int productId;
  final DateTime createAt;

  const FavoriteProductEntity({
    required this.favoriteProductId,
    required this.productId,
    required this.createAt,
  });

 static List<FavoriteProductEntity> fromList(List<dynamic> jsonList) {
    return jsonList.map((json) => FavoriteProductEntity.fromMap(json as Map<String, dynamic>)).toList();
  }

  @override
  List<Object> get props => [favoriteProductId, productId, createAt];

  FavoriteProductEntity copyWith({
    int? favoriteProductId,
    int? productId,
    DateTime? createAt,
  }) {
    return FavoriteProductEntity(
      favoriteProductId: favoriteProductId ?? this.favoriteProductId,
      productId: productId ?? this.productId,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favoriteProductId': favoriteProductId,
      'productId': productId,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory FavoriteProductEntity.fromMap(Map<String, dynamic> map) {
    return FavoriteProductEntity(
      favoriteProductId: map['favoriteProductId'] as int,
      productId: map['productId'] as int,
      createAt: DateTime.parse(map['createAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteProductEntity.fromJson(String source) =>
      FavoriteProductEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
