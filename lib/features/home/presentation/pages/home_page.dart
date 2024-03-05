import 'package:flutter/material.dart';

import '../../../search/presentation/components/search_bar_component.dart';
import '../components/category_list.dart';
import '../components/product_list.dart';

class HomePage extends StatelessWidget {
  // const HomePage({super.key});

  static const String routeName = 'home';
  final TextEditingController searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VTV'),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
            child: SearchBarComponent(controller: searchController),
          ),
        ],
      ),

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
