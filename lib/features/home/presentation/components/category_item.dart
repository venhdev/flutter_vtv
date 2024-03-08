import 'package:flutter/material.dart';

import '../../../../core/presentation/components/cached_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.title, required this.image});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: ImageCacheable(
              image,
              height: 70,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
