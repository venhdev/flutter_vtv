import 'package:flutter/material.dart';

// IconTextButton
class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.reversePosition = false,
    this.reverseDirection = false,
    this.backgroundColor,
    this.borderRadius,
    this.fontSize,
    this.iconSize,
    this.padding,
  });
  // Required parameters
  final IconData? icon; // Icon now is optional
  final String label;
  final void Function()? onPressed;

  // Optional parameters
  // Decorations
  final Color? backgroundColor;

  /// If true, the icon will be placed after the text
  final bool reversePosition;

  /// If true, the icon and text will be placed vertically
  final bool reverseDirection;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: padding ?? const EdgeInsets.all(0),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        backgroundColor: backgroundColor,
      ),
      icon: !reverseDirection
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // make the button as small as possible
              children: [
                if (!reversePosition) ...[
                  Icon(icon, size: iconSize),
                  const SizedBox(width: 4),
                  Text(label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      )),
                ] else ...[
                  Text(label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 4),
                  Icon(icon, size: iconSize),
                ]
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min, // make the button as small as possible
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!reversePosition) ...[
                  if (icon != null) Icon(icon, size: iconSize),
                  const SizedBox(width: 4),
                  Text(label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      )),
                ] else ...[
                  Text(label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 4),
                  if (icon != null) Icon(icon, size: iconSize),
                ]
              ],
            ),
    );
  }
}
