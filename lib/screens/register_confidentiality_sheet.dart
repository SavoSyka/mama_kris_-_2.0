// lib/register_confidentiality_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/next_button.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'package:mama_kris/screens/conf.dart';
import 'package:mama_kris/screens/license_screen.dart';

/// ConfidentialityPanel – первый шаг регистрации, отвечающий за показ
/// условий конфиденциальности. При нажатии на кнопку «Далее», если оба
/// чекбокса отмечены, вызывается onNext для перехода к следующему шагу.
class ConfidentialityPanel extends StatefulWidget {
  final double scaleX;
  final double scaleY;
  final VoidCallback onNext;

  const ConfidentialityPanel({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onNext,
  });

  @override
  _ConfidentialityPanelState createState() => _ConfidentialityPanelState();
}

class _ConfidentialityPanelState extends State<ConfidentialityPanel> {
  bool checkbox1 = false;
  bool checkbox2 = false;

  void _onNextPressed() {
    // print("Кнопка 'Далее' нажата");
    if (checkbox1 && checkbox2) {
      widget.onNext();
    } else {
      // print("Оба чекбокса должны быть отмечены");
      // Если нужно, можно показать сообщение об ошибке
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 396 * widget.scaleX,
      height: 727 * widget.scaleY,
      child: Stack(
        children: [
          // text1.svg – располагается с отступом 40 px сверху и 20 px слева от начала панели
          Positioned(
            top: 40 * widget.scaleY, // (369 - 329) = 40
            left: 20 * widget.scaleX, // (36 - 16) = 20
            child: SvgPicture.asset(
              'assets/register_confidentiality_sheet/text1.svg',
              width: 295 * widget.scaleX,
              height: 56 * widget.scaleY,
              fit: BoxFit.cover,
            ),
          ),
          // text2.svg
          Positioned(
            top: 106 * widget.scaleY, // (435 - 329) = 106
            left: 20 * widget.scaleX,
            child: SizedBox(
              width: 310 * widget.scaleX,
              height: 140 * widget.scaleY,
              child: Text(
                "Ознакомьтесь, пожалуйста, с документами и подтвердите согласие на обработку ваших персональных данных как пользователя нашей IT-платформы.",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w400,
                  fontSize: 14 * widget.scaleX,
                  height: 20 / 14,
                  letterSpacing: -0.1 * widget.scaleX,
                  color: const Color(0xFF596574),
                ),
              ),
            ),
          ),
          // Чекбокс 1
          Positioned(
            top: 226 * widget.scaleY, // (505 - 329) = 176
            left: 20 * widget.scaleX, // (36 - 16) = 20
            child: CustomCheckbox(
              initialValue: checkbox1,
              onChanged: (bool value) {
                setState(() {
                  checkbox1 = value;
                });
                // print("Первый чекбокс: $value");
              },
              scaleX: widget.scaleX,
              scaleY: widget.scaleY,
            ),
          ),
          // Кликабельный текст "Я принимаю условия Политики конфиденциальности и даю согласие..."
          // Координаты: абсолютные значения из макета: top:505, left:65; относительно панели: top = 505 - 329 = 176, left = 65 - 16 = 49.
          Positioned(
            top: 226 * widget.scaleY,
            left: 49 * widget.scaleX,
            child: SizedBox(
              width: 268 * widget.scaleX,
              height: 80 * widget.scaleY,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * widget.scaleX,
                    height: 20 / 14,
                    letterSpacing: -0.1 * widget.scaleX,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Я принимаю условия '),
                    TextSpan(
                      text: 'Политики конфиденциальности',
                      style: const TextStyle(
                        color: Color(0xFF00A80E),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder: (_, animation, secondaryAnimation) =>
                                  const ConfScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                const begin = Offset(1.0, 0.0); // справа
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                final tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                final offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          );
                          print("Политики конфиденциальности нажата");
                        },
                    ),
                    const TextSpan(
                      text:
                          ' и даю согласие\nна обработку моих персональных данных в соответствии с законодательством',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Чекбокс 2
          Positioned(
            top: 316 * widget.scaleY, // (595 - 329) = 266
            left: 20 * widget.scaleX,
            child: CustomCheckbox(
              initialValue: checkbox2,
              onChanged: (bool value) {
                setState(() {
                  checkbox2 = value;
                });
                // print("Второй чекбокс: $value");
              },
              scaleX: widget.scaleX,
              scaleY: widget.scaleY,
            ),
          ),
          Positioned(
            top: 316 * widget.scaleY, // Например, 595 - 329 = 266
            left: (65 - 16) * widget.scaleX, // Например, 65 - 16 = 49
            child: SizedBox(
              width: 268 * widget.scaleX,
              height: 20 * widget.scaleY,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * widget.scaleX,
                    height: 20 / 14,
                    letterSpacing: -0.1 * widget.scaleX,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Я соглашаюсь с '),
                    TextSpan(
                      text: 'Условиями использования',
                      style: const TextStyle(
                        color: Color(0xFF00A80E), // Цвет: #00A80E
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder: (_, animation, secondaryAnimation) =>
                                  const LicenseScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                const begin = Offset(1.0, 0.0); // справа
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                final tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                final offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          );
                          // print('Условия использования нажаты');
                          // Здесь можно добавить логику перехода на страницу условий
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Кнопка "Далее"
          Positioned(
            top: 366 * widget.scaleY, // (645 - 329) = 316
            left: 20 * widget.scaleX, // (36 - 16) = 20
            child: NextButton(
              scaleX: widget.scaleX,
              scaleY: widget.scaleY,
              onPressed: _onNextPressed,
            ),
          ),
          Positioned(
            top: 366 * widget.scaleY, // (645 - 329) = 316
            right: 20 * widget.scaleX, // (36 - 16) = 20
            child: PopButton(
              scaleX: widget.scaleX,
              scaleY: widget.scaleY,
              // onPressed: _onNextPressed,
            ),
          ),
        ],
      ),
    );
  }
}
