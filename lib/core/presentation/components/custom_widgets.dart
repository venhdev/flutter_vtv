import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.enableBack = true,
    this.textStyle,
    this.icon,
    this.text,
    this.onPressed,
  });
  factory MessageScreen.error([String? message, Icon? icon, void Function()? onPressed]) => MessageScreen(
        message: message ?? 'Lỗi không xác định',
        enableBack: false,
        icon: icon ?? const Icon(Icons.error),
        textStyle: const TextStyle(color: Colors.red),
        onPressed: onPressed,
      );

  final String message;
  final bool enableBack;
  final TextStyle? textStyle;
  final Icon? icon;
  final String? text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          GestureDetector(
            child: Text(
              message,
              style: textStyle,
            ),
            onLongPress: () => log(message), // for testing
          ),
          if (enableBack) ...[
            ElevatedButton(
              onPressed: () {
                // GoRouter.of(context).go('/home');
                onPressed != null ? onPressed!() : GoRouter.of(context).go('/home');
              },
              child: Text(text ?? 'Trang chủ'),
            ),
          ]
        ],
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
  });

  final Color? color;
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
