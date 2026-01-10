import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class CustomSpecialisation extends StatelessWidget {
  const CustomSpecialisation({super.key, this.specializations, this.onTap});

  final VoidCallback? onTap;
  final List<String>? specializations;

  @override
  Widget build(BuildContext context) {
    if (specializations == null && onTap == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Специализация',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),

                const SizedBox(height: 24),

                // Dynamic items with wrap
                if (specializations != null)
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          children: specializations!
                              .map((item) => _specialisationItem(item))
                              .toList(),
                        ),
                      ),
                    ],
                  ),

                if (onTap != null) ...[
                  const SizedBox(height: 20),
                  CustomButtonSec(
                    btnText:
                        specializations != null && specializations!.isNotEmpty
                        ? "Обновить специальность"
                        : '+  Добавить специальность',

                    onTap: onTap,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialisationItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x7F2E7866)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2E7866),
          fontSize: 12,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.30,
        ),
      ),
    );
  }
}
