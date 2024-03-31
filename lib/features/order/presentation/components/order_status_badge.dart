import 'package:flutter/material.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/helpers/helpers.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  final OrderStatus status;

  Color _color() {
    switch (status) {
      case OrderStatus.PENDING:
        return Colors.grey.shade400;
      case OrderStatus.SHIPPING:
        return Colors.blue;
      case OrderStatus.COMPLETED:
        return Colors.green;
      case OrderStatus.DELIVERED:
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

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
      color: _color(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(formatOrderStatus(status)),
      ),
    );
  }
}
