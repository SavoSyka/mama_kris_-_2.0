import 'package:flutter/material.dart';

class CustomDefaultPadding extends StatelessWidget {
  const CustomDefaultPadding({
    super.key,
    required this.child,
    this.bottom = 16,
    this.top = 16,
    this.left = 16,
    this.right = 16,
  });

  final double bottom;
  final double top;
  final double left;
  final double right;

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
    );
  }
}
