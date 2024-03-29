import 'package:flutter/material.dart';

import '../../../cart/domain/entities/voucher_entity.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem({
    super.key,
    required this.voucher,
    this.onSelected,
  });

  final VoucherEntity voucher;
  final void Function(VoucherEntity voucher)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigator.of(context).pop(voucher);
          onSelected?.call(voucher);
        },
        splashColor: Colors.red.withOpacity(0.2),
        overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Mã: ${voucher.code}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Tên: ${voucher.name}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                // voucher.description,
                "Mô tả: ${voucher.description}",
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                // voucher.description,
                "Loại: ${voucher.type}",
                style: const TextStyle(fontSize: 16.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    voucher.type != 'Giảm theo tiền' ? "Giảm ${voucher.discount}%" : "Giảm ${voucher.discount}đ",
                    style: const TextStyle(fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Còn lại ${voucher.quantity - voucher.quantityUsed} voucher",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
