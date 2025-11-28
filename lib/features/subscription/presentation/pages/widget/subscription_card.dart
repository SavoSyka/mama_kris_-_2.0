import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.period,
    // required this.discount,
    required this.price,
    this.isSelected = false,
    this.paidContent,
    required this.isApplicant,
  });
  final String period;
  // final String discount;
  final String price;
  final String? paidContent;

  final bool isSelected;
  final bool isApplicant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 30),

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x332E7866),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],

        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(
                color: isApplicant
                    ? AppPalette.primaryColor
                    : AppPalette.empPrimaryColor,
                width: 2,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 42,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      translatePeriod(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (period.toLowerCase() == 'year')
                      const Text(
                        'Самый популярный вариант',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.30,
                          color: AppPalette.primaryColor,
                        ),
                      ),
                  ],
                ),

                Text(
                  calculatePricePerMonth(),
                  style: const TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price руб.',
                      style: const TextStyle(
                        color: Color(0xFF596574),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (period.toLowerCase() == 'year')
                      const Text(
                        'Экономия 16 300',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          height: 1.30,
                          color: AppPalette.primaryColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String translatePeriod() {
    switch (period) {
      case 'MONTH':
        return '1 месяц';
      case 'YEAR':
        return '1 год';
      case "THREE_MONTHS":
        return '3 месяца';
      case 'HALF':
        return '6 месяцев';
      default:
        return 'месяц';
    }
  }

  String calculatePricePerMonth() {
    final pr = num.tryParse(price) ?? 0;

    int months;
    switch (period) {
      case 'MONTH':
        months = 1;
        break;
      case 'HALF':
        months = 6;
        break;
      case "THREE_MONTHS":
        months = 3;
        break;
      case 'YEAR':
        months = 12;
        break;
      default:
        months = 1;
    }

    final perMonth = pr / months;

    // Remove trailing .0 if it's a whole number
    final formatted = perMonth % 1 == 0
        ? perMonth.toInt().toString()
        : perMonth.toStringAsFixed(0);

    return "$formatted руб./мес";
  }
}
