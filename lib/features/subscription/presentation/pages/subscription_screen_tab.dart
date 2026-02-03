import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/appl_favorite_screen.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_screen.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_screen.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/emp_profile_screen.dart';
import 'package:mama_kris/features/emp/emp_support/presentation/emp_support_screen.dart';
import 'package:mama_kris/features/subscription/presentation/pages/subscription_screen.dart';

class SubscriptionScreenTab extends StatefulWidget {
  const SubscriptionScreenTab({super.key, this.pageIndex = 0});

  final int pageIndex;
  @override
  State<SubscriptionScreenTab> createState() => _SubscriptionScreenTabState();
}

class _SubscriptionScreenTabState extends State<SubscriptionScreenTab> {
  int _selectedIndex = 0;
  List<Widget> _pages = const [SubscriptionScreen()]; // Start with subscription
  List<BottomNavigationBarItem> _items = [];
  bool _isApplicant = true; // default fallback
  bool _isLoading = true; // Prevent build until ready

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _loadUserTypeAndSetupTabs();
  }

  Future<void> _loadUserTypeAndSetupTabs() async {
    try {
      final bool isApplicant = await sl<AuthLocalDataSource>().getUserType();

      final List<Widget> pages = [const SubscriptionScreen()];
      late List<BottomNavigationBarItem> items;

      if (isApplicant) {
        pages.addAll([
          const ApplFavoriteScreen(),
          const ApplSupportScreen(),
          const ApplProfileScreen(),
        ]);

        items = [
          const BottomNavigationBarItem(
            icon: CustomImageView(imagePath: MediaRes.homeIcon, width: 20),
            activeIcon: CustomImageView(
              imagePath: MediaRes.homeIcon,
              width: 20,
              color: AppPalette.primaryColor,
            ),
            label: "Вакансии",
          ),
          const BottomNavigationBarItem(
            icon: CustomImageView(imagePath: MediaRes.myOrders, width: 18),
            activeIcon: CustomImageView(
              imagePath: MediaRes.myOrders,
              width: 18,
              color: AppPalette.primaryColor,
            ),
            label: "Мои заказы",
          ),
          BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: MediaRes.support,
              width: 18,
              color: _selectedIndex == 2
                  ? AppPalette.primaryColor
                  : Colors.grey,
            ),
            activeIcon: CustomImageView(
              imagePath: MediaRes.support,
              width: 18,
              color: AppPalette.primaryColor,
            ),
            label: "Поддержка",
          ),
          const BottomNavigationBarItem(
            icon: CustomImageView(imagePath: MediaRes.profileIcon, width: 24),
            activeIcon: CustomImageView(
              imagePath: MediaRes.profileIcon,
              width: 24,
              color: AppPalette.primaryColor,
            ),
            label: "Профиль",
          ),
        ];
      } else {
        pages.addAll([
          // const EmpResumeScreen(),
          const EmpSupportScreen(),
          const EmpProfileScreen(),
        ]);

        items = [
          const BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: MediaRes.homeIcon,
              width: 28,
              color: Colors.grey, // inactive
            ),
            activeIcon: CustomImageView(
              imagePath: MediaRes.homeIcon,
              width: 28,
              color: AppPalette.empPrimaryColor, // active
            ),
            label: "Вакансии",
          ),
          // const BottomNavigationBarItem(
          //   icon: CustomImageView(
          //     imagePath: MediaRes.resumeIcon,
          //     width: 28,
          //     color: Colors.grey,
          //   ),
          //   activeIcon: CustomImageView(
          //     imagePath: MediaRes.resumeIcon,
          //     width: 28,
          //     color: AppPalette.empPrimaryColor,
          //   ),
          //   label: "Резюме",
          // ),
          const BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: MediaRes.support,
              width: 28,
              color: Colors.grey,
            ),
            activeIcon: CustomImageView(
              imagePath: MediaRes.support,
              width: 28,
              color: AppPalette.empPrimaryColor,
            ),
            label: "Поддержка",
          ),
          const BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: MediaRes.profileIcon,
              width: 28,
              color: Colors.grey,
            ),
            activeIcon: CustomImageView(
              imagePath: MediaRes.profileIcon,
              width: 28,
              color: AppPalette.empPrimaryColor,
            ),
            label: "Профиль",
          ),
        ];
      }

      // CORRECT: Only update UI if widget is still mounted
      if (mounted) {
        setState(() {
          _isApplicant = isApplicant;
          _pages = pages;
          _items = items;
          _selectedIndex = (_selectedIndex >= _pages.length)
              ? 0
              : _selectedIndex;
          _isLoading = false; // Now this will actually run!
        });
      }
    } catch (e) {
      debugPrint("Error loading user type: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didUpdateWidget(covariant SubscriptionScreenTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex && mounted) {
      final safeIndex = widget.pageIndex.clamp(0, _pages.length - 1);
      setState(() {
        _selectedIndex = safeIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or placeholder until tabs are ready
    if (_isLoading || _items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          selectedItemColor: _isApplicant
              ? AppPalette.primaryColor
              : AppPalette.empPrimaryColor,
          unselectedItemColor: Colors.grey,
          items: _items,
        ),
      ),
    );
  }
}
