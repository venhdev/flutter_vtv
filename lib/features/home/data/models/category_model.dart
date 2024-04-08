import 'dart:convert';

import 'package:vtv_common/vtv_common.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.categoryId,
    required super.name,
    required super.image,
    required super.description,
    required super.child,
    required super.status,
    super.parentId,
  });

  // toEntity
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      image: image,
      description: description,
      child: child,
      status: status,
      parentId: parentId,
    );
  }

  // fromEntity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      categoryId: entity.categoryId,
      name: entity.name,
      image: entity.image,
      description: entity.description,
      child: entity.child,
      status: entity.status,
      parentId: entity.parentId,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'categoryId': categoryId,
  //     'name': name,
  //     'image': image,
  //     'description': description,
  //     'child': child,
  //     'status': status,
  //   };
  // }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'].toInt() as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      child: map['child'] as bool,
      status: map['status'] as String,
      parentId: map['parentId'] as String?,
    );
  }

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<CategoryModel> fromJsonToList(String source) {
    final Map<String, dynamic> sourceMap = json.decode(source) as Map<String, dynamic>;
    final List<dynamic> mapList = sourceMap['categoryDTOs'] as List<dynamic>;

    return mapList.map((e) => CategoryModel.fromMap(e)).toList();
  }

  static List<CategoryModel> fromMapToList(Map<String, dynamic> mapList) {
    return (mapList['categoryDTOs'] as List<dynamic>)
        .map<CategoryModel>((e) => CategoryModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
