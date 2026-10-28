import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';

/// «Спасибо за заявку!» — показывается вместо формы после успешной отправки.
class AdRequestSuccessScreen extends StatelessWidget {
  const AdRequestSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AdSmallButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      'Спасибо за заявку!',
                      textAlign: TextAlign.center,
                      style: AdUi.manrope(
                        20,
                        FontWeight.w600,
                        color: AdUi.darkGreen,
                        lineHeight: 26,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Заявка на рекламу успешно отправлена! Наш менеджер свяжется с вами в течение 2 часов.',
                      textAlign: TextAlign.center,
                      style: AdUi.manrope(
                        12,
                        FontWeight.w500,
                        color: AdUi.grey,
                        lineHeight: 15.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
