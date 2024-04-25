import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/product_repository.dart';
import '../../pages/category_page.dart';
import 'category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: sl<ProductRepository>().getAllParentCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (error) => Center(
                  child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
                ),
                (r) => SizedBox(
                  height: 100,
                  child: GridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: r.data!
                        .map(
                          (category) => CategoryItem(
                            title: category.name,
                            image: category.image,
                            onTap: () async {
                              context.push(
                                '${CategoryPage.path}/${category.categoryId}',
                                extra: category.name,
                              );
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return Scaffold(
                              //         appBar: AppBar(
                              //           title: Text(category.name),
                              //         ),
                              //         
                              //         body: LazyProductListBuilder(
                              //           dataCallback: (page) {
                              //             return sl<ProductRepository>().getProductPageByCategory(
                              //               page,
                              //               8,
                              //               category.categoryId,
                              //             );
                              //           },
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }

            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          },
        ),
      ],
    );
  }
}
