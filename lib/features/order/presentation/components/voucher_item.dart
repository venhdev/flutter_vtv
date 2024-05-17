import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

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
                "Loại: ${StringUtils.getVoucherName(voucher.type.name)}",
                style: const TextStyle(fontSize: 16.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.getVoucherDiscount(type: voucher.type.name, discount: voucher.discount),
                    style: const TextStyle(fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Còn lại ${voucher.quantity - voucher.quantityUsed!} voucher",
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

class VoucherItemV2 extends StatelessWidget {
  const VoucherItemV2({
    super.key,
    required this.voucher,
    this.onPressed,
    this.onActionPressed,
    required this.actionLabel,
  });

  final VoucherEntity voucher;
  final void Function(VoucherEntity voucher)? onPressed;

  final ValueChanged<VoucherEntity>? onActionPressed;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: InkWell(
        onTap: onPressed != null
            ? () => onPressed!(voucher)
            : () => showDialog(
                  context: context,
                  builder: (context) => VoucherDetailDialog(voucher: voucher),
                ),
        borderRadius: BorderRadius.circular(4.0),
        child: SizedBox(
          height: 100.0,
          child: Row(
            children: [
              //# voucher type
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                width: 100.0,
                height: 100.0,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      StringUtils.getVoucherName(voucher.type.name, lineBreak: true),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ribeye(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),

              //# voucher info: name and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      voucher.name,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      voucher.description,
                      style: VTVTheme.hintTextStyle.copyWith(fontSize: 13.0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    //# progress bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          StringUtils.getVoucherDiscount(type: voucher.type.name, discount: voucher.discount),
                          style: const TextStyle(fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    LinearProgressIndicator(
                      value: voucher.quantityUsed! / voucher.quantity,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      semanticsLabel: "Voucher Progress Bar",
                    ),
                    Text(
                      'Đã dùng ${(voucher.quantityUsed! / voucher.quantity * 100).toInt()}%',
                      style: VTVTheme.hintTextStyle,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),

              //# voucher action
              InkWell(
                onTap: onActionPressed != null ? () => onActionPressed!(voucher) : null,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      actionLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherDetailDialog extends StatelessWidget {
  const VoucherDetailDialog({super.key, required this.voucher});

  final VoucherEntity voucher;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              voucher.name,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              // voucher.description,
              'Mô tả: ${voucher.description}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Loại: ${StringUtils.getVoucherName(voucher.type.name)} - ${StringUtils.getVoucherTypeName(voucher.type)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Mã: ${voucher.code}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Số lượng: ${voucher.quantity}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Số lượng đã dùng: ${voucher.quantityUsed}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Giảm giá: ${StringUtils.getVoucherDiscount(type: voucher.type.name, discount: voucher.discount)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Ngày bắt đầu: ${StringUtils.convertDateTimeToString(voucher.startDate)}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Ngày kết thúc: ${StringUtils.convertDateTimeToString(voucher.endDate)}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
