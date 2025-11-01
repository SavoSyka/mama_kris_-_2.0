import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleSelectionPanel extends StatelessWidget {
  final double scaleX;
  final double scaleY;
  final VoidCallback onExecutorPressed;
  final VoidCallback onEmployerPressed;

  const RoleSelectionPanel({
    super.key,
    required this.scaleX,
    required this.scaleY,
    required this.onExecutorPressed,
    required this.onEmployerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SVG-текст 1 (text1.svg)
        Positioned(
          top: 40 * scaleY,
          left: 20 * scaleX,
          child: SvgPicture.asset(
            'assets/role_sheet/text1.svg',
            width: 207 * scaleX,
            height: 28 * scaleY,
            fit: BoxFit.cover,
          ),
        ),
        // SVG-текст 2 (text2.svg)
        Positioned(
          top: 78 * scaleY,
          left: 20 * scaleX,
          child: SvgPicture.asset(
            'assets/role_sheet/text2.svg',
            width: 274 * scaleX,
            height: 40 * scaleY,
            fit: BoxFit.cover,
          ),
        ),
        // Первая кнопка "Я - исполнитель (соискатель)"
        Positioned(
          top: 138 * scaleY,
          left: 20 * scaleX,
          child: Container(
            width: 357 * scaleX,
            height: 111 * scaleY,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15 * scaleX),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x78E7E7E7),
                  offset: Offset(0, 4 * scaleY),
                  blurRadius: 19 * scaleX,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onExecutorPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15 * scaleX),
                ),
                elevation: 0,
                padding: EdgeInsets.fromLTRB(
                  0 * scaleX,
                  27 * scaleY,
                  50 * scaleX,
                  27 * scaleY,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 239 * scaleX,
                    height: 28 * scaleY,
                    child: Text(
                      "Я - исполнитель (соискатель)",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                        fontSize: 18 * scaleX,
                        height: 28 / 18,
                        letterSpacing: -0.18 * scaleX,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * scaleY),
                  SizedBox(
                    width: 241 * scaleX,
                    height: 20 * scaleY,
                    child: Text(
                      "Ищу вакансии и задания на удаленке.",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                        fontSize: 14 * scaleX,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: const Color(0xFF596574),
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Вторая кнопка "Я - заказчик (работодатель)"
        Positioned(
          top: 269 * scaleY,
          left: 20 * scaleX,
          child: Container(
            width: 357 * scaleX,
            height: 111 * scaleY,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15 * scaleX),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x78E7E7E7),
                  offset: Offset(0, 4 * scaleY),
                  blurRadius: 19 * scaleX,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onEmployerPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15 * scaleX),
                ),
                elevation: 0,
                padding: EdgeInsets.only(
                  left: 0 * scaleX,
                  top: 27 * scaleY,
                  right: 50 * scaleX,
                  bottom: 27 * scaleY,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 239 * scaleX,
                    height: 28 * scaleY,
                    child: Text(
                      "Я - заказчик (работодатель)",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                        fontSize: 18 * scaleX,
                        height: 28 / 18,
                        letterSpacing: -0.18 * scaleX,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * scaleY),
                  SizedBox(
                    width: 241 * scaleX,
                    height: 20 * scaleY,
                    child: Text(
                      "Ищу сотрудника в свой проект на удаленке.",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                        fontSize: 14 * scaleX,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: const Color(0xFF596574),
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
