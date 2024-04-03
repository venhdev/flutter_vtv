// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../entities/review_entity.dart';

class ReviewResp extends Equatable {
  final int count;
  final int productId;
  final int averageRating;
  final List<ReviewEntity> reviews;

  const ReviewResp({
    required this.count,
    required this.productId,
    required this.averageRating,
    required this.reviews,
  });

  @override
  List<Object> get props => [count, productId, averageRating, reviews];

  ReviewResp copyWith({
    int? count,
    int? productId,
    int? averageRating,
    List<ReviewEntity>? reviews,
  }) {
    return ReviewResp(
      count: count ?? this.count,
      productId: productId ?? this.productId,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'productId': productId,
      'averageRating': averageRating,
      'reviewDTOs': reviews.map((x) => x.toMap()).toList(),
    };
  }

  factory ReviewResp.fromMap(Map<String, dynamic> map) {
    return ReviewResp(
      count: map['count'] as int,
      productId: map['productId'] as int,
      averageRating: map['averageRating'] as int,
      reviews: List<ReviewEntity>.from(
        (map['reviewDTOs'] as List<dynamic>).map<ReviewEntity>(
          (x) => ReviewEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewResp.fromJson(String source) => ReviewResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
