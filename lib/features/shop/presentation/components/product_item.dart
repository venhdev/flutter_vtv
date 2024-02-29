import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.title, required this.price, required this.image});

  final String title;
  final int price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(image),
          ),
          Text(title),
          Text(formatCurrency(price)),
        ],
      ),
    );
  }
}
