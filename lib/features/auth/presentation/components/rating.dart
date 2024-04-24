import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.rating,
    this.iconSize,
    this.fontSize,
    this.showRatingBar = false,
    this.showRatingText = true,
    this.customText,
  });

  final double rating;

  /// default is 18.0
  final double? iconSize;
  final double? fontSize;
  final bool showRatingBar;
  final bool showRatingText;
  final String? customText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        showRatingBar
            ? RatingBarIndicator(
                rating: rating,
                itemSize: iconSize ?? 18.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              )
            : Icon(Icons.star, color: Colors.amber, size: iconSize),
        if (showRatingText)
          Text(
            customText ?? rating.toString(),
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
      ],
    );
  }
}
