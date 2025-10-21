import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Drawer? drawer;
  final bool extendBodyBehindAppBar;

  const CustomScaffold({
    super.key,
    this.appBar,
    this.body,
    this.backgroundColor,
    this.floatingActionButton,
    this.drawer,
    this.extendBodyBehindAppBar=false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}