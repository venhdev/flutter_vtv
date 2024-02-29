import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/constants/api.dart';
import 'package:http/http.dart' as http;

import '../../../../service_locator.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/category_repository.dart';
import '../../domain/repository/product_repository.dart';
import '../components/category_item.dart';
import '../components/product_item.dart';
import '../components/product_list.dart';

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
          ProductList(),
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
