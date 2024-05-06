import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

Future<T?> showDialogToConfirmCheckout<T>(BuildContext context) async {
  return await showDialogToConfirm(
    context: context,
    title: 'Xác nhận đặt hàng',
    content: 'Bạn có chắc chắn muốn đặt hàng?',
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    confirmText: 'Xác nhận',
    dismissText: 'Hủy',
    confirmBackgroundColor: Colors.green.shade200,
    dismissBackgroundColor: Colors.grey.shade400,
  );
}
