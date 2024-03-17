import 'package:flutter/material.dart';

Future<T?> showMyDialogToConfirm<T>({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? onConfirm,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center, // Căn giữa tiêu đề
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(content),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Không', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () async {
                    onConfirm?.call();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Có', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
