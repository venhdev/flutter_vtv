import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/category_repository.dart';
import 'category_item.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Xem thêm'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder(
          future: sl<CategoryRepository>().getAllParentCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (l) => Center(
                  child: Text('Error: $l', style: const TextStyle(color: Colors.red)),
                ),
                (r) => GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: r.data
                      .map(
                        (category) => CategoryItem(
                          title: category.name,
                          image: category.image,
                        ),
                      )
                      .toList(),
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
