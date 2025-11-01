// lib/login_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'package:mama_kris/screens/register_role_sheet.dart';
import 'package:mama_kris/screens/registration_flow.dart';
import 'package:mama_kris/utils/login_logic.dart'; // Импорт бизнес-логики
import 'package:mama_kris/utils/google_apple_auth.dart';
import 'package:mama_kris/screens/pass_reset_email.dart';

class LoginSheetContent extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginSheetContent({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.emailController,
    required this.passwordController,
  });

  Widget _buildLoginForm(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 329 * scaleY,
          left: 16 * scaleX,
          child: Container(
            width: 396 * scaleX,
            height: 627 * scaleY,
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
            child: Stack(
              children: [
                Positioned(
                  top: 40 * scaleY,
                  left: 20 * scaleX,
                  child: SvgPicture.asset(
                    'assets/login_sheet/text.svg',
                    width: 249 * scaleX,
                    height: 28 * scaleY,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 88 * scaleY,
                  left: 20 * scaleX,
                  child: CustomTextField(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    hintText: "Email",
                    isPassword: false,
                    enableToggle: false,
                    controller: emailController,
                  ),
                ),
                Positioned(
                  top: 168 * scaleY,
                  left: 20 * scaleX,
                  child: CustomTextField(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    hintText: "Пароль",
                    isPassword: true,
                    enableToggle: true,
                    controller: passwordController,
                  ),
                ),
                Positioned(
                  top: 258 * scaleY,
                  left: 20 * scaleX,
                  child: NextButton(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    onPressed: () async {
                      bool navigated = await loginAndContinue(
                        context: context,
                        emailController: emailController,
                        passwordController: passwordController,
                      );
                      // Если loginAndContinue вернул false, значит нужно закрыть окно и показать панель выбора ролей.
                      if (!navigated) {
                        Navigator.pop(context);
                        showRoleSelectionPanel(context);
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 258 * scaleY, // (645 - 329) = 316
                  right: 20 * scaleX, // (36 - 16) = 20
                  child: PopButton(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    // onPressed: _onNextPressed,
                  ),
                ),
                Positioned(
                  top: 333 * scaleY,
                  left: 75 * scaleX,
                  right: 75 * scaleX,
                  child: SvgPicture.asset(
                    'assets/welcome_screen/text3.svg',
                    height: 29 * scaleY,
                  ),
                ),
                buildSocialButtons(
                  top: 372,
                  scaleX: scaleX,
                  scaleY: scaleY,
                  onGooglePressed: () => onGooglePressed(context),
                  onApplePressed: () => onApplePressed(context),
                  context: context,
                ),
                Positioned(
                  top: 490 * scaleY,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        foregroundColor:
                            WidgetStateProperty.all(const Color(0xFF00A80E)),
                        textStyle: WidgetStateProperty.resolveWith<TextStyle>((
                          Set<WidgetState> states,
                        ) {
                          if (states.contains(WidgetState.pressed)) {
                            return TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Jost',
                              fontSize: 16 * scaleX,
                            );
                          }
                          return TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Jost',
                            fontSize: 16 * scaleX,
                          );
                        }),
                      ),
                      onPressed: () {
                        showPassResetEmailSheet(context);
                      },
                      child: const Text('Сбросить пароль'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoginForm(context);
  }
}

/// Показывает панель выбора ролей.
void showRoleSelectionPanel(BuildContext context) {
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
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 329 * scaleY,
              left: 16 * scaleX,
              child: Container(
                width: 396 * scaleX,
                height: 627 * scaleY,
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
                child: RoleSelectionPanel(
                  scaleX: scaleX,
                  scaleY: scaleY,
                  onExecutorPressed: () {
                    // Для исполнителя отправляем выбор "Looking for job"
                    updateChoice('Looking for job', context);
                  },
                  onEmployerPressed: () {
                    // Для заказчика отправляем выбор "Have vacancies"
                    updateChoice('Have vacancies', context);
                  },
                ),
              ),
            ),
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

/// Показывает модальное окно с LoginSheetContent.
void showLoginSheet(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  double scaleX = screenWidth / 428;
  double scaleY = screenHeight / 956;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "LoginSheet",
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) {
            return LoginSheetContent(
              scaleX: scaleX,
              scaleY: scaleY,
              emailController: emailController,
              passwordController: passwordController,
            );
          },
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
