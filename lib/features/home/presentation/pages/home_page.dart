import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
import '../components/search_bar_component.dart';
import '../../domain/repository/product_repository.dart';
import '../components/category_list.dart';
import '../components/product_list_builder.dart';
import 'search_products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VTV",
          style: GoogleFonts.ribeye(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SearchBarComponent(
              clearOnSubmit: true,
              onSubmitted: (text) => context.go(SearchProductsPage.route, extra: text),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Category
          const Category(),
          // Product
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: null,
                  child: Text('Xem thêm'),
                ),
              ],
            ),
          ),
          ProductListBuilder(
            future: sl<ProductRepository>().getSuggestionProductsRandomly(1, 10),
          ),
        ],
      ),
    );
  }
}
