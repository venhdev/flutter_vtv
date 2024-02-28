import 'package:flutter/material.dart';

import 'components/category_item.dart';
import 'components/product_item.dart';

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
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            CategoryItem(
              title: 'Thời trang',
              icon: Icons.accessibility,
            ),
            CategoryItem(
              title: 'Điện thoại',
              icon: Icons.phone,
            ),
            CategoryItem(
              title: 'Máy tính',
              icon: Icons.computer,
            ),
            CategoryItem(
              title: 'Đồ gia dụng',
              icon: Icons.home,
            ),
            CategoryItem(
              title: 'Thời trang',
              icon: Icons.accessibility,
            ),
            CategoryItem(
              title: 'Điện thoại',
              icon: Icons.phone,
            ),
            CategoryItem(
              title: 'Máy tính',
              icon: Icons.computer,
            ),
            CategoryItem(
              title: 'Đồ gia dụng',
              icon: Icons.home,
            ),
          ],
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
