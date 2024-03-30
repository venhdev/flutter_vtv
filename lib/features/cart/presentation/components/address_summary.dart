import 'package:flutter/material.dart';

import '../../../profile/domain/entities/address_dto.dart';

class AddressSummary extends StatelessWidget {
  const AddressSummary({
    super.key,
    required this.address,
    this.onTap,
    this.prefixIcon = Icons.location_on_outlined,
    this.suffixIcon = Icons.chevron_right,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    this.maxLines,
    this.overflow,
    this.color,
    this.border ,
  });

  final AddressEntity address;

  final void Function()? onTap;

  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Override color of container (overlayColor will be ignored)
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(),
      borderRadius: BorderRadius.circular(12),
      overlayColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.2)),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: border ?? Border.all(color: Colors.grey.shade500),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        margin: margin,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon address
            if (prefixIcon != null) Icon(prefixIcon),
            const SizedBox(width: 6),
            // address info
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    style: const TextStyle(fontSize: 14),
                    maxLines: maxLines,
                    overflow: overflow,
                    TextSpan(
                      text: 'Địa chỉ nhận hàng: ',
                      children: [
                        TextSpan(
                          text:
                              '${address.fullAddress}, ${address.wardFullName}, ${address.districtFullName}, ${address.provinceFullName}',
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
                    'Người nhận: ${address.fullName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  // phone
                  Text(
                    'Số điện thoại: ${address.phone}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            // > icon
            if (suffixIcon != null) Icon(suffixIcon),
          ],
        ),
      ),
    );
  }
}
