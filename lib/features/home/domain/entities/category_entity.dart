import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int categoryId;
  final String name;
  final String image;
  final String description;
  final bool adminOnly;
  final String status;

  const CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.adminOnly,
    required this.status,
  });

  CategoryEntity copyWith({
    int? categoryId,
    String? name,
    String? image,
    String? description,
    bool? adminOnly,
    String? status,
  }) {
    return CategoryEntity(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      adminOnly: adminOnly ?? this.adminOnly,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'CategoryEntity(categoryId: $categoryId, name: $name, image: $image, description: $description, adminOnly: $adminOnly, status: $status)';
  }

  @override
  List<Object?> get props => [
        categoryId,
        name,
        image,
        description,
        adminOnly,
        status,
      ];
}
