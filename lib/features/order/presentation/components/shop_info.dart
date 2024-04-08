import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

class ShopInfo extends StatelessWidget {
  const ShopInfo({
    super.key,
    required this.shop,
    this.padding = const EdgeInsets.only(bottom: 8.0),
  });

  final ShopEntity shop;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(shop.avatar),
          ),
          const SizedBox(width: 4),
          Text(
            shop.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
