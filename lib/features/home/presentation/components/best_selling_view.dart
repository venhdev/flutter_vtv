import 'package:flutter/material.dart';

import '../../domain/dto/product_dto.dart';

class BestSellingScreen extends StatelessWidget {
  const BestSellingScreen({super.key, required this.bestSellingProducts});

  final List<String> bestSellingProducts;

  // final List<Map<String, dynamic>> bestSellingProducts = [
  //   {
  //     'imageUrl': 'https://via.placeholder.com/150',
  //     'title': 'Product 1',
  //     'price': 100,
  //   },
  //   {
  //     'imageUrl': 'https://via.placeholder.com/150',
  //     'title': 'Product 2',
  //     'price': 200,
  //   },
  //   {
  //     'imageUrl': 'https://via.placeholder.com/150',
  //     'title': 'Product 3',
  //     'price': 300,
  //   },
  //   {
  //     'imageUrl': 'https://via.placeholder.com/150',
  //     'title': 'Product 4',
  //     'price': 400,
  //   },
  //   {
  //     'imageUrl': 'https://via.placeholder.com/150',
  //     'title': 'Product 5',
  //     'price': 500,
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm bán chạy'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bestSellingProducts.length,
        itemBuilder: (context, index) {
          // final product = bestSellingProducts[index];
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Image.network(
                // product['imageUrl'],
                bestSellingProducts[index],
                fit: BoxFit.cover, // Make the image smaller when the size is not enough
              ),
            ),
          );
        },
      ),
    );
  }
}
