import 'package:flutter/material.dart';

class CustomShadowContainer extends StatelessWidget {
  const CustomShadowContainer({
    super.key,
    required this.child,
    this.horMargin = 0.0,
    this.borderRadius =5.0
  });
  final Widget child;
  final double horMargin;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horMargin),
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        shadows: const [
          BoxShadow(
            color: Color(0x3FC9C9C9),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
