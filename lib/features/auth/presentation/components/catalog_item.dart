
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  const CatalogItem({
    super.key,
    required this.catalogName,
    required this.catalogDescription,
    this.icon,
    this.backgroundColor,
    this.onPressed,
  });

  final String catalogName;
  final String catalogDescription;
  final Icon? icon;
  final Color? backgroundColor;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                catalogName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon ?? const SizedBox(),
            ],
          ),
          // underline
          Text(
            catalogDescription,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
