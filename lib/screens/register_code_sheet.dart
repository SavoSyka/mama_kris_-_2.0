import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'registration_flow.dart'; // чтобы иметь доступ к verifyCodeFunction
import 'package:mama_kris/utils/google_apple_auth.dart';

/// CodePanel – шаг для ввода кода верификации.
/// Callback onNext принимает токен, полученный после успешной проверки.
class CodePanel extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final String email;
  final Function(String) onNext;

  const CodePanel({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.email,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Stack(
      children: [
        // Заголовок (SVG)
        Positioned(
          top: 40 * scaleY,
          left: 20 * scaleX,
          child: SizedBox(
            width: 300 * scaleX,
            child: Text(
              "Введите код, отправленный на электронную почту",
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.w700,
                fontSize: 22 * scaleX,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // Поле ввода кода подтверждения
        Positioned(
          top: 156 * scaleY,
          left: 20 * scaleX,
          child: CustomTextField(
            scaleX: scaleX,
            scaleY: scaleY,
            hintText: "Код подтверждения",
            isPassword: false,
            enableToggle: false,
            controller: codeController,
          ),
        ),
        // Кнопка "Далее"
        Positioned(
          top: 246 * scaleY,
          left: 20 * scaleX,
          child: NextButton(
            scaleX: scaleX,
            scaleY: scaleY,
            onPressed: () async {
              // print("Кнопка 'Далее' нажата (CodePanel)");
              final code = codeController.text.trim();
              final token = await verifyCodeFunction(context, email, code);
              if (token != null) {
                onNext(token);
              }
            },
          ),
        ),
        Positioned(
          top: 246 * scaleY, // (645 - 329) = 316
          right: 20 * scaleX, // (36 - 16) = 20
          child: PopButton(
            scaleX: scaleX,
            scaleY: scaleY,
            // onPressed: _onNextPressed,
          ),
        ),
        // Текст для соцсетей (SVG)
        Positioned(
          top: 320.78 * scaleY,
          left: 75 * scaleX,
          right: 75 * scaleX,
          child: SvgPicture.asset(
            'assets/welcome_screen/text3.svg',
            height: 29 * scaleY,
          ),
        ),
        buildSocialButtons(
          top: 360,
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
