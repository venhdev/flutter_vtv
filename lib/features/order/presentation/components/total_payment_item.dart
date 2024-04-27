import 'package:flutter/widgets.dart';

class TotalPaymentItem extends StatelessWidget {
  const TotalPaymentItem({
    super.key,
    required this.label,
    required this.price,
    this.labelStyle,
    this.priceStyle,
  });

  final String label;
  final String price;

  final TextStyle? labelStyle;
  final TextStyle? priceStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(price, style: priceStyle),
      ],
    );
  }
}
