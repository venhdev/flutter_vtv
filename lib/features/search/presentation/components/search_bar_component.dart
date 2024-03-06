import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/search_products_page.dart';

class SearchBarComponent extends StatefulWidget {
  // final TextEditingController controller;
  final String? keywords;

  // Set the initial text of the controller to keywords when available
  // if (keywords != null) {
  //   controller.text = keywords!;
  // }
  const SearchBarComponent({super.key, this.keywords});

  @override
  State<SearchBarComponent> createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  final keyWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.keywords != null) {
      keyWordController.text = widget.keywords!;
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
                    controller: keyWordController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'Tìm kiếm sản phẩm',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (keyWordController.text.isNotEmpty) {
                      context.go(SearchProductsPage.route, extra: keyWordController.text);
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
