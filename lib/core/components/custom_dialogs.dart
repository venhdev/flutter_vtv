import 'package:flutter/material.dart';

Future<T?> showMyDialogToConfirm<T>({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback? onConfirm,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
