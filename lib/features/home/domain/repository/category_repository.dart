import 'package:flutter_vtv/core/constants/typedef.dart';

import '../entities/category_entity.dart';

abstract class CategoryRepository {
  FRespData<List<CategoryEntity>> getAllParentCategories();
}
