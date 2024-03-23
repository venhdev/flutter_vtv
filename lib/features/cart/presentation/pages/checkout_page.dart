import 'package:flutter/material.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/cart_repository.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    super.key,
    required this.cartIds,
  });

  static const String routeName = 'checkout';
  static const String path = '/home/cart/checkout';

  final List<String> cartIds;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<CartRepository>().createOrderByCartIds(cartIds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.toString());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
