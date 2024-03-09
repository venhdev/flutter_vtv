import 'package:flutter/material.dart';

class SearchBarComponent extends StatefulWidget {
  const SearchBarComponent({
    super.key,
    this.clearOnSubmit = false,
    this.controller,
    required this.onSubmitted,
  });

  // final String? keywords;
  final bool clearOnSubmit;
  final void Function(String text)? onSubmitted;
  final TextEditingController? controller;

  @override
  State<SearchBarComponent> createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      searchController = widget.controller!;
    } else {
      searchController = TextEditingController();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
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
                      controller: searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: 'Tìm kiếm sản phẩm',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _handleSubmitted(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _handleSubmitted(searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      widget.onSubmitted?.call(value);
      if (widget.clearOnSubmit) searchController.clear();
    }
  }
}
