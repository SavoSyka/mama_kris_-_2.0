import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/applicant_home/presentation/applicant_home_page.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/favorite_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/home_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/profile_tab.dart';
import 'package:mama_kris/features/home/presentation/pages/tabs/resume_tab.dart';
import 'package:mama_kris/features/support/presentation/support_page.dart';

class ApplicantTabScreen extends StatefulWidget {
  const ApplicantTabScreen({super.key});

  @override
  State<ApplicantTabScreen> createState() => _ApplicantTabScreenState();
}

class _ApplicantTabScreenState extends State<ApplicantTabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ApplicantHomePage(),
    ResumeTab(),
    SupportPage(),
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
              label: AppTextContents.myOrders,
            ),
            BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: MediaRes.support,
                width: 22,
                color: _selectedIndex == 2
                    ? AppPalette.primaryColor
                    : Colors.grey,
              ),
              label: AppTextContents.support,
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
