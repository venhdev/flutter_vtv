import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.enableBack = true,
    this.textStyle,
  });
  factory MessageScreen.error([String? message]) => MessageScreen(
        message: message ?? 'Unknown error',
        enableBack: false,
      );

  final String message;
  final bool enableBack;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Text(
              message,
              style: textStyle,
            ),
            onLongPress: () => log(message), // for testing
          ),
          if (enableBack) ...[
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go back'),
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
