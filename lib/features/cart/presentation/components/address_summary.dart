import 'package:flutter/material.dart';

class AddressSummary extends StatelessWidget {
  const AddressSummary({
    super.key,
    this.onTap,
    required this.address,
    required this.receiver,
    required this.phone,
    this.icon = Icons.chevron_right,
    this.margin,
  });

  final void Function()? onTap;
  final String address;
  final String receiver;
  final String phone;

  final IconData? icon;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
        margin: margin ?? const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon address
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 6),
            // address info
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: 'Địa chỉ nhận hàng: ',
                      children: [
                        TextSpan(
                          text: address,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // receiver
                  Text(
                    'Người nhận: $receiver',
                    style: const TextStyle(fontSize: 14),
                  ),
                  // phone
                  Text(
                    'Số điện thoại: $phone',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            // > icon
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
