import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/screens/vacancies_screen.dart';
import 'package:mama_kris/screens/favorite_screen.dart';
import 'package:mama_kris/screens/chat_screen.dart';
import 'package:mama_kris/screens/profile_screen.dart';
import 'package:mama_kris/screens/order_screen.dart';
import 'package:mama_kris/screens/job_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/widgets/change_alert.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final bool showChangeDialog;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.showChangeDialog = false,
  });

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<int> _navigationStack = [0]; // Стек вкладок
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;
  int _previousIndex = 0;
  int _currentIndex = 0;
  int _slideDirection = 1; // 1 = вперед (справа), -1 = назад (слева)

  // Список экранов, который будет установлен асинхронно
  List<Widget>? _screens;

  @override
  void initState() {
    super.initState();
    if (widget.showChangeDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showChangeAlert(context);
      });
    }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadNavigationScreens();
    _updateAnimations();
  }

  Future<void> _loadNavigationScreens() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentPage = prefs.getString('current_page');

    int index = widget.initialIndex;

    debugPrint("Current page $currentPage");

    setState(() {
      if (currentPage == 'job') {
        _screens = [
          const OrderScreen(),
          const JobListScreen(),
          const ChatScreen(),
          const ProfileScreen(),
        ];
      } else {
        _screens = [
          const VacanciesScreen(),
          const FavoriteScreen(),
          const ChatScreen(),
          const ProfileScreen(),
        ];
      }

      _currentIndex = index;
      _previousIndex = index;
      _navigationStack = [index];
    });
  }

  void _updateAnimations() {
    _slideOutAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: _slideDirection == 1 ? const Offset(-1, 0) : const Offset(1, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _slideInAnimation =
        Tween<Offset>(
          begin: _slideDirection == 1
              ? const Offset(1, 0)
              : const Offset(-1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  void onItemTapped(int index) {
    if (_navigationStack.last == index) return;

    setState(() {
      _previousIndex = _navigationStack.last;
      _slideDirection = index > _previousIndex ? 1 : -1;
      _navigationStack.removeWhere((element) => element == index);
      _navigationStack.add(index);
      _currentIndex = index;
      _updateAnimations();
    });

    _animationController.forward(from: 0);
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        int lastIndex = _navigationStack.removeLast();
        _previousIndex = lastIndex;
        _currentIndex = _navigationStack.last;
        _slideDirection = _currentIndex > _previousIndex ? 1 : -1;
        _updateAnimations();
      });
      _animationController.forward(from: 0);
      return false;
    }
    return true;
  }

  Widget _buildNavItem({
    required String label,
    required String inactiveIconPath,
    required String activeIconPath,
    required int index,
    required double scaleX,
    required double scaleY,
  }) {
    bool isActive = (_navigationStack.last == index);
    Color textColor = isActive
        ? const Color(0xFF00A80E)
        : const Color(0xFF979AA0);
    String iconPath = isActive ? activeIconPath : inactiveIconPath;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.translucent, // важно!
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ), // увеличиваем хитбокс
        alignment: Alignment.center,
        width: 105 * scaleX,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20 * scaleX, // уменьшенная иконка
              height: 20 * scaleY,
            ),
            SizedBox(height: 4 * scaleY),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.w600,
                fontSize: 15 * scaleX,
                height: 18 / 15,
                letterSpacing: 0.45 * scaleX,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Если _screens еще не загружены, показываем индикатор загрузки
    if (_screens == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            // Исходящий экран (старый)
            SlideTransition(
              position: _slideOutAnimation,
              child: _screens![_previousIndex],
            ),
            // Въезжающий новый экран
            SlideTransition(
              position: _slideInAnimation,
              child: _screens![_currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: screenWidth,
          height: 103 * scaleY,
          color: const Color(0xFFFBFCFC),
          padding: EdgeInsets.symmetric(horizontal: 0 * scaleX),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                label: "Главная",
                inactiveIconPath: "assets/bottom_bar/inactive/home.svg",
                activeIconPath: "assets/bottom_bar/active/home.svg",
                index: 0,
                scaleX: scaleX,
                scaleY: scaleY,
              ),

              _buildNavItem(
                label: "Мои заказы",
                inactiveIconPath: "assets/bottom_bar/inactive/orders.svg",
                activeIconPath: "assets/bottom_bar/active/orders.svg",
                index: 1,
                scaleX: scaleX,
                scaleY: scaleY,
              ),

              _buildNavItem(
                label: "Поддержка",
                inactiveIconPath: "assets/bottom_bar/inactive/chat.svg",
                activeIconPath: "assets/bottom_bar/active/chat.svg",
                index: 2,
                scaleX: scaleX,
                scaleY: scaleY,
              ),
              _buildNavItem(
                label: "Профиль",
                inactiveIconPath: "assets/bottom_bar/inactive/profile.svg",
                activeIconPath: "assets/bottom_bar/active/profile.svg",
                index: 3,
                scaleX: scaleX,
                scaleY: scaleY,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
