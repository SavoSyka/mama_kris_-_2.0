import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/appl_favorite_screen.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/appl_home_screen.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_screen.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_screen.dart';

class ApplHomeTabScreen extends StatefulWidget {
  const ApplHomeTabScreen({super.key, this.pageIndex = 0});

  final int pageIndex;
  @override
  State<ApplHomeTabScreen> createState() => _ApplHomeTabScreenState();
}

class _ApplHomeTabScreenState extends State<ApplHomeTabScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    ApplHomeScreen(),
    ApplFavoriteScreen(),
    ApplSupportScreen(),

    ApplProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    debugPrint("init state ${widget.pageIndex} ");
    setState(() {
      _selectedIndex = widget.pageIndex;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(ApplHomeTabScreen oldWidget) {
    // super.didUpdateWidget(oldWidget);
    // setState(() {
    //   _selectedIndex = widget.pageIndex.clamp(0, _pages.length - 1);
    //   debugPrint("Updated selectedIndex to ${widget.pageIndex}");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: IndexedStack(index: _selectedIndex, children: _pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppPalette.primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.homeIcon,
                width: 20,
                color: _selectedIndex == 0
                    ? AppPalette.primaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.home,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.myOrders,
                width: 18,
                color: _selectedIndex == 1
                    ? AppPalette.primaryColor
                    : Colors.grey,
              ),
              label:"Мои заказы",
            ),

            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.support,
                width: 18,
                color: _selectedIndex == 2
                    ? AppPalette.primaryColor
                    : Colors.grey,
              ),
              label: "Поддержка",
            ),

            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.profileIcon,
                width: 24,
                color: _selectedIndex == 3
                    ? AppPalette.primaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.profile,
            ),
          ],
        ),
      ),
    );
  }
}
