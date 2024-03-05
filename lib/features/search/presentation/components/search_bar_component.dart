import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/search_products_page.dart';

class SearchBarComponent extends StatelessWidget {
  final TextEditingController controller;
  final String? keywords;

  SearchBarComponent({super.key, required this.controller, this.keywords}) {
    // Set the initial text of the controller to keywords when available
    if (keywords != null) {
      controller.text = keywords!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'Tìm kiếm sản phẩm',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      final searchKeywords = controller.text;
                      context.go('/home/${SearchProductsPage.routeName}', extra: searchKeywords);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}





