import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.rating,
    this.iconSize,
    this.fontSize,
  });

  final String rating;
  final double? iconSize;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: iconSize),
        Text(
          rating,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
