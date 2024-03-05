import 'package:flutter/material.dart';

import '../components/search_products.dart';

class SearchProductsPage extends StatelessWidget {
  static const String routeName = 'search';

  final String? keywords;


  const SearchProductsPage({super.key, required this.keywords});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: ListView(
        children: [
          SearchProducts(keywords: keywords),
        ],
      ),
    );
  }
}
