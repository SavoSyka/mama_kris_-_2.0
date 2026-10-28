import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

/// Карточка тарифа: цена в месяц/за неделю, цена в день и выгода против помесячной оплаты.
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.period,
    required this.price,
    this.isSelected = false,
    required this.isApplicant,
    required this.pricePerMonth,
    this.monthPrice,
  });
  final String period;
  final String pricePerMonth;
  final String price;

  /// Цена тарифа MONTH — от неё считаем «−54%»
  final num? monthPrice;

  final bool isSelected;
  final bool isApplicant;

  /// Тариф, который подсвечиваем как самый выгодный по соотношению цены и срока
  static const highlighted = 'THREE_MONTHS';

  static const _days = {
    'WEEK': 7,
    'MONTH': 30,
    'THREE_MONTHS': 90,
    'HALF': 180,
    'YEAR': 365,
  };
  static const _months = {'MONTH': 1, 'THREE_MONTHS': 3, 'HALF': 6, 'YEAR': 12};

  static String rub(num value) {
    final digits = value.round().toString();
    return '${digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+$)'), (_) => ' ')} ₽';
  }

  num get _price => num.tryParse(price) ?? 0;

  int? get discountPercent {
    final months = _months[period];
    if (months == null ||
        months < 2 ||
        monthPrice == null ||
        monthPrice! <= 0) {
      return null;
    }
    final perMonth = _price / months;
    final percent = ((1 - perMonth / monthPrice!) * 100).round();
    return percent > 0 ? percent : null;
  }

  @override
  Widget build(BuildContext context) {
    final accent = isApplicant
        ? AppPalette.primaryColor
        : AppPalette.empPrimaryColor;
    final months = _months[period];
    final days = _days[period];
    final isBest = period == highlighted;
    final discount = discountPercent;

    final mainPrice = months == null
        ? '${rub(_price)} за неделю'
        : '${rub(_price / months)}/мес';
    final details = [
      if (months != null && months > 1)
        '${rub(_price)} за ${translatePeriod()}',
      if (days != null) '${rub(_price / days)} в день',
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: isBest ? const Color(0xFFF2FBF3) : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x332E7866),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: accent, width: 2)
            : Border.all(
                color: isBest
                    ? accent.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                translatePeriod(capitalized: true),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isBest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Выгодный',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mainPrice,
                style: TextStyle(
                  color: isBest ? accent : const Color(0xFF1F2937),
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (discount != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '−$discount%',
                    style: const TextStyle(
                      color: Color(0xFFE5482D),
                      fontSize: 14,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              details,
              style: const TextStyle(
                color: Color(0xFF596574),
                fontSize: 13,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String translatePeriod({bool capitalized = false}) {
    switch (period) {
      case 'MONTH':
        return '1 месяц';
      case 'YEAR':
        return capitalized ? '1 год' : 'год';
      case 'WEEK':
        return '1 неделя';
      case "THREE_MONTHS":
        return '3 месяца';
      case 'HALF':
        return '6 месяцев';
      default:
        return period;
    }
  }
}
