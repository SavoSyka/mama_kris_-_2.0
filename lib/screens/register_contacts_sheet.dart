import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'package:mama_kris/utils/google_apple_auth.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;

/// ContactsPanel – шаг, где вводятся email, отображаемое имя и пароль.
/// Callback onNext принимает три параметра: email, displayName и password.
class ContactsPanel extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final Function(String, String, String, String) onNext;

  const ContactsPanel({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final displayNameController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();
    return Stack(
      children: [
        // Заголовок (SVG)
        Positioned(
          top: 20 * scaleY,
          left: 20 * scaleX,
          child: SvgPicture.asset(
            'assets/register_contacts_sheet/text.svg',
            width: 219 * scaleX,
            height: 56 * scaleY,
            fit: BoxFit.cover,
          ),
        ),
        // Поле ввода Email
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
        // Поле ввода "Отображаемое имя"
        Positioned(
          top: 160 * scaleY,
          left: 20 * scaleX,
          child: CustomTextField(
            scaleX: scaleX,
            scaleY: scaleY,
            hintText: "Отображаемое имя",
            isPassword: false,
            enableToggle: false,
            controller: displayNameController,
          ),
        ),
        // Поле ввода "Телефон"
        Positioned(
          top: 232 * scaleY,
          left: 20 * scaleX,
          child: CustomTextField(
            scaleX: scaleX,
            scaleY: scaleY,
            hintText: "Телефон",
            isPassword: false,
            enableToggle: false,
            controller: phoneController,
          ),
        ),
        // Поле ввода "Пароль"
        Positioned(
          top: 304 * scaleY,
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
        // Кнопка "Далее"
        Positioned(
          top: 386 * scaleY,
          left: 20 * scaleX,
          child: NextButton(
            scaleX: scaleX,
            scaleY: scaleY,
            onPressed: () {
              // print("Кнопка 'Далее' нажата (ContactsPanel)");
              final email = emailController.text.trim();
              final displayName = displayNameController.text.trim();
              final password = passwordController.text.trim();
              final rawPhone = phoneController.text.trim();

              final cleanedPhone = funcs.validateAndFormatPhone(
                rawPhone,
                context,
              );
              if (cleanedPhone == null) return; // Ошибка уже показана

              onNext(email, displayName, password, cleanedPhone);
            },
          ),
        ),
        Positioned(
          top: 386 * scaleY, // (645 - 329) = 316
          right: 20 * scaleX, // (36 - 16) = 20
          child: PopButton(
            scaleX: scaleX,
            scaleY: scaleY,
            // onPressed: _onNextPressed,
          ),
        ),
        // Текст для соцсетей (SVG)
        Positioned(
          top: 450 * scaleY,
          left: 75 * scaleX,
          right: 75 * scaleX,
          child: SvgPicture.asset(
            'assets/welcome_screen/text3.svg',
            height: 29 * scaleY,
          ),
        ),
        buildSocialButtons(
          top: 490,
          scaleX: scaleX,
          scaleY: scaleY,
          onGooglePressed: () => onGooglePressed(context),
          onApplePressed: () => onApplePressed(context),
          context: context,
        ),
      ],
    );
  }
}
