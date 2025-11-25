import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;
  final bool alignTitleToEnd;
  final bool isEmployee;
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.onLeadingPressed,
    this.alignTitleToEnd = true,
    this.isEmployee = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
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
                // const Spacer(), // Push title to the end
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.black),
                    softWrap: true,
                  ),
                ),
                
                SizedBox(width: 16,),
              ],
            )
          : Text(title, style: const TextStyle(color: Colors.black)),
      leading: showLeading
          ? IconButton(
              onPressed: onLeadingPressed ?? () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(6), // Touch target padding
                decoration: AppTheme.cardDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,

                  color: isEmployee
                      ? AppPalette.empPrimaryColor
                      : AppPalette.primaryColor,
                ),
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
