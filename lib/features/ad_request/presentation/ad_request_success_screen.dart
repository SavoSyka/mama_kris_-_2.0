import 'package:flutter/material.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';

/// «Спасибо за заявку!» — прозрачный оверлей поверх приложения:
/// крестик сверху и белая панель с текстом снизу (как в макете).
class AdRequestSuccessScreen extends StatelessWidget {
  const AdRequestSuccessScreen({super.key});

  /// Заменяет форму оверлеем — под ним видно экран, с которого открывали форму.
  static Route<void> route() => PageRouteBuilder<void>(
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => const AdRequestSuccessScreen(),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    void close() => Navigator.of(context).maybePop();

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: close,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: AdSmallButton(icon: Icons.close, onTap: close),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Color(0x40FFFFFF), blurRadius: 20),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
          ),
        ],
      ),
    );
  }
}
