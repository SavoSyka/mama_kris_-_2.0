import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final VoidCallback onPressed;
  final String text;

  const NextButton({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onPressed,
    this.text = 'Далее',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162.33 * scaleX,
      height: 44.78 * scaleY,
      decoration: BoxDecoration(
        color: const Color(0xFF00A80E),
        borderRadius: BorderRadius.circular(13 * scaleX),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCFFFD1),
            offset: Offset(0, 4 * scaleY),
            blurRadius: 19 * scaleX,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A80E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13 * scaleX),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: SizedBox(
            width: 70 * scaleX,
            height: 35 * scaleY,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                  fontSize: 18 * scaleX,
                  height: 28 / 18,
                  letterSpacing: -0.54 * scaleX,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopButton extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  // final VoidCallback onPressed;
  final String text;

  const PopButton({
    super.key,
    required this.scaleX,
    required this.scaleY,
    // required this.onPressed,
    this.text = 'Назад',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162.33 * scaleX,
      height: 44.78 * scaleY,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(13 * scaleX),
        boxShadow: [
          BoxShadow(
            color: const Color(0xe7e7e7781),
            offset: Offset(0, 4 * scaleY),
            blurRadius: 19 * scaleX,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13 * scaleX),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: SizedBox(
            width: 70 * scaleX,
            height: 35 * scaleY,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                  fontSize: 18 * scaleX,
                  height: 28 / 18,
                  letterSpacing: -0.54 * scaleX,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
