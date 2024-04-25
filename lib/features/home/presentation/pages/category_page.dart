import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product/lazy_product_list_builder.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.categoryId, required this.title});

  static const String routeName = 'category';
  static const String path = '/home/category'; // '/:categoryId'

  final int categoryId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // BUG: got error when scroll to the end of the list (categoryId = 1)
        child: LazyProductListBuilder(
          dataCallback: (page) {
            return sl<ProductRepository>().getProductPageByCategory(
              page,
              8,
              categoryId,
            );
          },
        ),
      ),
    );
  }
}
