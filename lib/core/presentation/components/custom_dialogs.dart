import 'package:flutter/material.dart';

Future<T?> showMyDialogToConfirm<T>({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? onConfirm,
  String confirmText = 'Có',
  String dismissText = 'Không',
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
        content: Text(content, textAlign: TextAlign.center),
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
                  child: Text(dismissText,
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () async {
                    onConfirm?.call();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(confirmText,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
