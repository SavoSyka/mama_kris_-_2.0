// lib/registration_flow_dialog.dart
import 'package:flutter/material.dart';
import 'registration_flow.dart';

void showRegistrationFlowDialog(BuildContext context) {
  // Базовые размеры макета из Figma: 428 x 956
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "RegistrationFlow",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      // Оборачиваем содержимое диалога в Scaffold,
      // чтобы SnackBar отображались корректно (и сообщения дублировались в терминале через showSnack).
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Панель регистрации
            Positioned(
              top: 229 * scaleY,
              left: 16 * scaleX,
              child: Container(
                width: 396 * scaleX,
                height: 727 * scaleY,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15 * scaleX),
                    topRight: Radius.circular(15 * scaleX),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x78E7E7E7),
                      offset: Offset(0, 4 * scaleY),
                      blurRadius: 19 * scaleX,
                    ),
                  ],
                ),
                child: RegistrationFlow(scaleX: scaleX, scaleY: scaleY),
              ),
            ),
            // Если RegistrationFlow уже содержит прогресс-бар, дополнительный можно убрать.
            // Если же нужен статичный прогресс-бар поверх всего, задайте ему нужную ширину.
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
