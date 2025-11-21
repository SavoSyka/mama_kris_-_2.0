import 'package:flutter/material.dart';

class ExpandedScrollWrapper extends StatelessWidget {
  const ExpandedScrollWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IntrinsicHeight(child: Center(child: child)),
    );
  }
}
