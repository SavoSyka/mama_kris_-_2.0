import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/favorite_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/home_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/profile_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/resume_tab.dart';

class EmployeHomePage extends StatefulWidget {
  const EmployeHomePage({super.key});

  @override
  State<EmployeHomePage> createState() => _EmployeHomePageState();
}

class _EmployeHomePageState extends State<EmployeHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    ResumeTab(),
    FavoriteTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _selectedIndex, children: _pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppPalette.secondaryColor,
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
                imagePath: MediaRes.myOrders,
                width: 28,
                color: _selectedIndex == 1
                    ? AppPalette.secondaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.myOrders,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.support,
                width: 28,
                color: _selectedIndex == 2
                    ? AppPalette.secondaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.support,
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
