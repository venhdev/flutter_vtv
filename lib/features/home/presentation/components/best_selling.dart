import 'package:flutter/material.dart';

class BestSelling extends StatelessWidget {
  const BestSelling({
    super.key,
    required this.bestSellingProductImages,
    required this.bestSellingProductNames,
  });

  final List<String> bestSellingProductImages;
  final List<String> bestSellingProductNames;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: bestSellingProductImages.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                bestSellingProductImages[index],
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  bestSellingProductNames[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
