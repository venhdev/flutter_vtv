import 'package:flutter/material.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({
//     super.key,
//     required this.child,
//     this.backgroundColor = Colors.white,
//     this.padding = const EdgeInsets.all(8),
//   });

//   final Widget child;
//   final Color? backgroundColor;
//   final EdgeInsetsGeometry? padding;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: padding,
//       decoration: BoxDecoration(
//         // border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//         color: backgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: const Offset(0, 2), // changes position of shadow
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.border,
    this.useBoxShadow = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final bool useBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(4),
        color: backgroundColor,
        boxShadow: useBoxShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
