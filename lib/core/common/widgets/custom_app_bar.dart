import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading; // Control whether to show the back button
  final VoidCallback? onLeadingPressed;
  final bool alignTitleToEnd; // New parameter to align title to the end

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.onLeadingPressed,
    this.alignTitleToEnd = true, // Default to left-aligned
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable default to customize
      backgroundColor: Colors.transparent,
      centerTitle: false,

      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: alignTitleToEnd
          ? Row(
              children: [
                const Spacer(), // Push title to the end
                Text(
                  title,
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            )
          : Text(title, style: const TextStyle(color: Colors.black)),
      leading: showLeading
          ? IconButton(
              onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
              icon: Container(
                padding: const EdgeInsets.all(6), // Touch target padding
                decoration: AppTheme.cardDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              tooltip: 'Назад',
              splashRadius: 24,
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
