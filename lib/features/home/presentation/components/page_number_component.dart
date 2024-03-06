import 'package:flutter/material.dart';

class PageNumberComponent extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;

  const PageNumberComponent({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => TextButton(
            onPressed: () {
              onPageChanged(index + 1); // Pages are usually 1-based
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                color: (index + 1 == currentPage) ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
