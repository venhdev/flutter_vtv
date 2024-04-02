import 'package:flutter/material.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/helpers/helpers.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  final OrderStatus status;

// WAITING,
//   PENDING,
//   SHIPPING,
//   COMPLETED,
//   CANCELLED,
//   PROCESSING,
//   CANCELED,

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: getOrderStatusBackgroundColor(status),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(formatOrderStatusName(status), style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
