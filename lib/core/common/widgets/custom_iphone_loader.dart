import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

/// iPhone-style animated loader (beautiful & reusable)
class IPhoneLoader extends StatefulWidget {
  const IPhoneLoader({super.key, this.loaderColor, this.height});
  final Color? loaderColor;
  final double? height;

  @override
  State<IPhoneLoader> createState() => _IPhoneLoaderState();
}

class _IPhoneLoaderState extends State<IPhoneLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _scaleAnim = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: widget.height ?? 100,
        width: 200,
        child: Container(
          /// Soft gradient background (iPhone “light” vibe)
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                Color(0xFFE0F2FE), // very light sky-blue
                Colors.white,
              ],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.light),
                child: CupertinoActivityIndicator(
                  radius: 28, // big enough to feel premium
                  animating: true,
                  color:
                      widget.loaderColor ??
                      AppPalette.primaryColor, // iOS system blue
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
