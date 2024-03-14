// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int categoryId;
  final String name;
  final String image;
  final String description;
  final bool child;
  final String status;
  final String? parentId;

  const CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.child,
    required this.status,
    this.parentId,
  });

  @override
  List<Object?> get props {
    return [
      categoryId,
      name,
      image,
      description,
      child,
      status,
      parentId,
    ];
  }

  CategoryEntity copyWith({
    int? categoryId,
    String? name,
    String? image,
    String? description,
    bool? child,
    String? status,
    String? parentId,
  }) {
    return CategoryEntity(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      child: child ?? this.child,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
    );
  }
}
