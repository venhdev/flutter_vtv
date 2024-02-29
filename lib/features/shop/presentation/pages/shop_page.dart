import 'package:flutter/material.dart';

import '../components/category_list.dart';
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
