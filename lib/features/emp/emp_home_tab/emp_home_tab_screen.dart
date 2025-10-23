import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/appl_favorite_screen.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/appl_home_screen.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_screen.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_screen.dart';
import 'package:mama_kris/features/applicant_home/presentation/applicant_home_page.dart';
import 'package:mama_kris/features/applicant_orders/presentations/pages/my_orders_page.dart';
import 'package:mama_kris/features/applicant_profile/presentation/pages/applicant_profile_page.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/favorite_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/home_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/profile_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/resume_tab.dart';
import 'package:mama_kris/features/support/presentation/support_page.dart';

class EmpHomeTabScreen extends StatefulWidget {
  const EmpHomeTabScreen({super.key, this.pageIndex = 0});

  final int pageIndex;
  @override
  State<EmpHomeTabScreen> createState() => _ApplHomeTabScreenState();
}

class _ApplHomeTabScreenState extends State<EmpHomeTabScreen> {
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
  void didUpdateWidget(EmpHomeTabScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _selectedIndex = widget.pageIndex.clamp(0, _pages.length - 1);
      debugPrint("Updated selectedIndex to ${widget.pageIndex}");
    });
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
          selectedItemColor: AppPalette.empPrimaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.homeIcon,
                width: 28,
                color: _selectedIndex == 0
                    ? AppPalette.secondaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.vacancies,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.resumeIcon,
                width: 28,
                color: _selectedIndex == 1
                    ? AppPalette.secondaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.resume,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.favoriteIcon,
                width: 28,
                color: _selectedIndex == 2
                    ? AppPalette.secondaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.favorite,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.profileIcon,
                width: 28,
                color: _selectedIndex == 3
                    ? AppPalette.secondaryColor
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
