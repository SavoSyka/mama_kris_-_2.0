import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBar extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final VoidCallback onHomeTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  const BottomBar({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onHomeTap,
    required this.onOrdersTap,
    required this.onChatTap,
    required this.onProfileTap,
  });

  Widget _buildItem(String iconPath, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 24 * scaleX, height: 24 * scaleY),
            SizedBox(height: 4 * scaleY),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.w600,
                fontSize: 15 * scaleX,
                height: 18 / 15,
                letterSpacing: 0.03 * (15 * scaleX), // 3% от размера шрифта
                color: const Color(0xFF979AA0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 427 * scaleX,
      height: 103 * scaleY,
      padding: EdgeInsets.only(
        top: 8 * scaleY,
        left: 8 * scaleX,
        right: 8 * scaleX,
      ),
      decoration: BoxDecoration(
        // color: const Color(0xFFFBFCFC),
        color: Colors.green,
        borderRadius: BorderRadius.circular(15 * scaleX),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            'assets/bottom_bar/inactive/home.svg',
            'Главная',
            onHomeTap,
          ),
          _buildItem(
            'assets/bottom_bar/inactive/orders.svg',
            'Мои заказы',
            onOrdersTap,
          ),
          _buildItem('assets/bottom_bar/inactive/chat.svg', 'Чат', onChatTap),
          _buildItem(
            'assets/bottom_bar/inactive/profile.svg',
            'Профиль',
            onProfileTap,
          ),
        ],
      ),
    );
  }
}
