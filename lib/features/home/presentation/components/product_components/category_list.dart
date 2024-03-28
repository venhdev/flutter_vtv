import 'package:flutter/material.dart';

import '../../../../../core/presentation/components/image_cacheable.dart';
import '../../../../../service_locator.dart';
import '../../../domain/repository/product_repository.dart';

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
            // TextButton(
            //   onPressed: null,
            //   child: Text('Xem thêm'),
            // ),
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
                (l) => Center(
                  child: Text('Error: $l',
                      style: const TextStyle(color: Colors.red)),
                ),
                (r) => SizedBox(
                  height: 100,
                  child: GridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: r.data
                        .map(
                          (category) => CategoryItem(
                            title: category.name,
                            image: category.image,
                          ),
                        )
                        .toList(),
                  ),
                  // child: GridView.count(
                  //   crossAxisCount: 1,
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.horizontal,
                  //   mainAxisSpacing: 4,
                  // children: List.generate(
                  //   10,
                  //   (index) => CategoryItem(
                  //     title: 'Category $index',
                  //     image: 'https://via.placeholder.com/150',
                  //   ),
                  // ),
                  // ),
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

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.title,
    required this.image,
    this.height = 70,
  });

  final String title;
  final String image;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      // more border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: ImageCacheable(
              image,
              height: height,
              fit: BoxFit.fitHeight,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
