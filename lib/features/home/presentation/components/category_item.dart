import 'package:flutter/material.dart';

import '../../../../core/presentation/components/image_cacheable.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.title,
    required this.image,
    this.height = 70,
  });

  final String title;
  final String image;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      // more border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: ImageCacheable(
              image,
              height: height,
              fit: BoxFit.fitHeight,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BestSellingProductItem extends StatelessWidget {
  const BestSellingProductItem({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
    this.height = 70,
  });

  final String title;
  final String image;
  final double height;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ImageCacheable(
                image,
                height: height,
                fit: BoxFit.fitHeight,
                borderRadius: BorderRadius.circular(6.0),
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
      ),
    );
  }
}
