import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/category_repository.dart';
import '../components/category_item.dart';
import '../components/product_item.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  static const String routeName = 'shop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.background,
      //   title: const Text('Home Page'),
      // ),
      body: ListView(
        children: const [
          // Category
          Category(),
          // Product
          Product(),
        ],
      ),
    );
  }
}

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
                  child: Text('Error: $l'),
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

            // return GridView.count(
            //   crossAxisCount: 4,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: const [
            //     CategoryItem(
            //       title: 'Thời trang',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Điện thoại',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Máy tính',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Đồ gia dụng',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Thời trang',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Điện thoại',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Máy tính',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //     CategoryItem(
            //       title: 'Đồ gia dụng',
            //       image: 'https://via.placeholder.com/150',
            //     ),
            //   ],
            // );
          },
        ),
      ],
    );
  }
}

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            log('get category list');
            final resultEither = await sl<CategoryRepository>().getAllParentCategories();

            resultEither.fold(
              (l) => log('error: $l'),
              (r) => log('result: $r'),
            );
          },
          child: const Text('Button'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Danh sách sản phẩm',
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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ProductItem(
              title: 'Áo thun',
              price: 100000,
              image: 'https://via.placeholder.com/150',
            ),
            ProductItem(
              title: 'Quần jean',
              price: 200000,
              image: 'https://via.placeholder.com/150',
            ),
            ProductItem(
              title: 'Áo thun',
              price: 100000,
              image: 'https://via.placeholder.com/150',
            ),
            ProductItem(
              title: 'Quần jean',
              price: 200000,
              image: 'https://via.placeholder.com/150',
            ),
          ],
        ),
      ],
    );
  }
}
