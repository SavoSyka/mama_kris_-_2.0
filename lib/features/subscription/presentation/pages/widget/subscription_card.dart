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
    required this.isApplicant
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
            ? Border.all(color: 
            
            isApplicant ?
            AppPalette.primaryColor:
            AppPalette.empPrimaryColor
            
            , width: 2)
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
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        '$period месяц',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          height: 1.30,
                        ),
                      ),
                      // const Text(
                      //   'Хит!',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     fontFamily: 'Manrope',
                      //     fontWeight: FontWeight.w600,
                      //     height: 1.30,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 16,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            '$price руб.',
                            style: const TextStyle(
                              color: Color(0xFF596574),
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              height: 1.30,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Выгода $discount%',
                      //   style: const TextStyle(
                      //     fontSize: 10,
                      //     fontFamily: 'Manrope',
                      //     fontWeight: FontWeight.w500,
                      //     height: 1.30,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                if (paidContent != null)
                  Text(
                    paidContent!.replaceAll('\n', " "),
                    // 'Access to all premium features for ${subscription.price} per ${subscription.type}.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF596574),
                    ),
                    textAlign: TextAlign.left,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
