import 'dart:convert';

import 'package:flutter_vtv/features/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.categoryId,
    required super.name,
    required super.image,
    required super.description,
    required super.adminOnly,
    required super.status,
  });

  // toEntity
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      image: image,
      description: description,
      adminOnly: adminOnly,
      status: status,
    );
  }

  // fromEntity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      categoryId: entity.categoryId,
      name: entity.name,
      image: entity.image,
      description: entity.description,
      adminOnly: entity.adminOnly,
      status: entity.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'image': image,
      'description': description,
      'adminOnly': adminOnly,
      'status': status,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'].toInt() as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      adminOnly: map['adminOnly'] as bool,
      status: map['status'] as String,
    );
  }

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<CategoryModel> fromJsonList(String source) {
    final Map<String, dynamic> sourceMap = json.decode(source) as Map<String, dynamic>;
    final List<dynamic> mapList = sourceMap['categoryAdminDTOs'] as List<dynamic>;

    return mapList.map((e) => CategoryModel.fromMap(e)).toList();
  }
}
