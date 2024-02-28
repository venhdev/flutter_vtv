

class CategoryEntity {
  final int categoryId;
  final String name;
  final String image;
  final String description;
  final bool adminOnly;
  final String status;

  CategoryEntity({
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
  bool operator ==(covariant CategoryEntity other) {
    if (identical(this, other)) return true;

    return other.categoryId == categoryId &&
        other.name == name &&
        other.image == image &&
        other.description == description &&
        other.adminOnly == adminOnly &&
        other.status == status;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^ name.hashCode ^ image.hashCode ^ description.hashCode ^ adminOnly.hashCode ^ status.hashCode;
  }
}
