import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/search_products_page.dart';

class SearchBarComponent extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm sản phẩm',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              context.go('/home/${SearchProductsPage.routeName}', extra: controller.text);
            }
          },
        ),
      ],
    );
  }
}
