import 'package:flutter/material.dart';

import '../components/search_bar_component.dart';
import '../components/search_products.dart';

class SearchProductsPage extends StatelessWidget {
  static const String routeName = 'search';
  static const String route = '/home/$routeName';

  final String? keywords;

  SearchProductsPage({super.key, required this.keywords});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VTV'),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: SearchBarComponent(keywords: keywords),
          ),
        ],
      ),
      body: SearchProducts(keywords: keywords),
    );
  }
}
