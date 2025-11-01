import 'package:flutter/material.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/next_button.dart';

class PassResetCodePage extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final VoidCallback onNext;
  final TextEditingController codeController;

  const PassResetCodePage({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onNext,
    required this.codeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Отступ сверху 40 пикселей, остальные отступы по 20 пикселей (с учётом масштабирования)
      padding: EdgeInsets.only(
        top: 40 * scaleY,
        left: 20 * scaleX,
        right: 20 * scaleX,
        bottom: 20 * scaleY,
      ),
      child: Column(
        key: const ValueKey('codePage'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок, расположенный с отступом от начала панели
          Text(
            "Введите код, отправленный на электронную почту",
            style: TextStyle(
              fontFamily: 'Jost',
              fontWeight: FontWeight.w700,
              fontSize: 24 * scaleX,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20 * scaleY),
          // Поле ввода кода подтверждения
           CustomTextField(
              scaleX: scaleX,
              scaleY: scaleY,
              hintText: "Код подтверждения",
              isPassword: false,
              enableToggle: false,
              controller: codeController,
            ),

          SizedBox(height: 80 * scaleY),
          // Кнопка "Далее"
          NextButton(
              scaleX: scaleX,
              scaleY: scaleY,
              onPressed: onNext,
            ),

          SizedBox(height: 200 * scaleY),
        ],
      ),
    );
  }
}
