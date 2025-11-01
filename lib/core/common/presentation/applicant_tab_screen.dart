import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/applicant_orders/presentations/pages/my_orders_page.dart';
import 'package:mama_kris/features/applicant_profile/presentation/pages/applicant_profile_page.dart';

class ApplicantTabScreen extends StatefulWidget {
  const ApplicantTabScreen({super.key, required this.pageIndex});

  final int pageIndex;
  @override
  State<ApplicantTabScreen> createState() => _ApplicantTabScreenState();
}

class _ApplicantTabScreenState extends State<ApplicantTabScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    Scaffold(),
    MyOrdersPage(),
    ApplicantProfilePage(),
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
  void didUpdateWidget(ApplicantTabScreen oldWidget) {
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
                imagePath: MediaRes.profileIcon,
                width: 24,
                color: _selectedIndex == 2
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
