import 'package:flutter/material.dart';

class CustomDefaultPadding extends StatelessWidget {
  const CustomDefaultPadding({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16), child: child);
  }
}
