import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.borderColor,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = true,
    this.obscureText = false,
    this.checkEmpty = true,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final Color? borderColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final bool isRequired;
  final bool obscureText;
  final bool checkEmpty;
  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  // properties for touchable text field
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: readOnly,
          onTap: onTap,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? Theme.of(context).colorScheme.primaryContainer,
                width: 2.0,
              ),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty && checkEmpty) {
                  return 'Chưa nhập ${label.toLowerCase()}';
                }
                return null;
              },
        ),
      ],
    );
  }
}
