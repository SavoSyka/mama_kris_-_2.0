import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';


class CustomAppBarWithActions extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;
  final bool alignTitleToEnd;
  final bool isEmployee;

  const CustomAppBarWithActions({
    super.key,
    required this.title,
    required this.actions,
    this.showLeading = true,
    this.onLeadingPressed,
    this.alignTitleToEnd = false,
    this.isEmployee = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: _buildShrinkableTitle(),
      actions: actions,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      centerTitle: false,
      leading: showLeading
          ? _buildLeadingButton(context)
          : null,
    );
  }

  Widget _buildShrinkableTitle() {
    if (!alignTitleToEnd) {
      return _fittedText(title);
    }

    return Row(
      children: [
        Expanded(child: _fittedText(title, TextAlign.end)),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _fittedText(String text, [TextAlign align = TextAlign.start]) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: align == TextAlign.end
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    return IconButton(
      onPressed: onLeadingPressed ?? () => context.pop(),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: AppTheme.cardDecoration.copyWith(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color:
              isEmployee ? AppPalette.empPrimaryColor : AppPalette.primaryColor,
        ),
      ),
      splashRadius: 24,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
