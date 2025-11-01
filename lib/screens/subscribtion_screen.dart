import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'package:mama_kris/screens/payment_webview_page.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:flutter/gestures.dart';
import 'package:mama_kris/screens/conf.dart';
import 'package:mama_kris/screens/license_screen.dart';

enum SubscriptionType { oneTime, annual }

class SubscribtionScreen extends StatefulWidget {
  final int jobId;
  const SubscribtionScreen({super.key, required this.jobId});

  @override
  _SubscribtionScreenState createState() => _SubscribtionScreenState();
}

class _SubscribtionScreenState extends State<SubscribtionScreen> {
  SubscriptionType selectedSubscription = SubscriptionType.oneTime;
  bool agreeTerms = false;

  /// Функция, которая вызывается при нажатии на основную кнопку.
  void _onProceedButtonPressed() async {
    // Определяем тариф в зависимости от выбранной подписки
    String tariffType =
    selectedSubscription == SubscriptionType.oneTime ? "ONCE" : "YEAR";
    final int jobId = widget.jobId;

    // Генерируем ссылку для оплаты
    final paymentLink = await funcs.generatePaymentLink(
      tariffType: tariffType,
      demoMode: false,
      jobId: jobId,
    );

    if (paymentLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка генерации ссылки для оплаты")),
      );
      return;
    }

    // Переход на экран с WebView для отображения ссылки внутри приложения
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewPage(
          url: paymentLink,
          callback: (WebViewRequest request) {
            if (request == WebViewRequest.success) {
              // Обработка успешного платежа
              // print("Платеж успешно выполнен");
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, animation, secondaryAnimation) =>
                  const MainScreen(initialIndex: 1),
                  transitionsBuilder: (_, animation, __, child) {
                    final tween = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
                    (_) => false,
              );
            } else {
              // Обработка неудачного платежа
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, animation, secondaryAnimation) =>
                  const MainScreen(initialIndex: 1),
                  transitionsBuilder: (_, animation, __, child) {
                    final tween = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
                    (_) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Платеж не выполнен, повторите попытку позже.",
                  ),
                ),
              );
              // print("Платеж не выполнен");
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    var children = [
      // Зеленый блюр (фон)
      Positioned(
        top: 108 * scaleY,
        left: 0,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            width: 428 * scaleX,
            height: 195 * scaleY,
            decoration: BoxDecoration(
              color: const Color(0xFFCFFFD1).withOpacity(0.22),
              borderRadius: BorderRadius.circular(20 * scaleX),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20 * scaleX),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 83, sigmaY: 83),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
      // Логотип
      Positioned(
        top: 65 * scaleY,
        left: 101 * scaleX,
        child: SvgPicture.asset(
          'assets/welcome_screen/logo.svg',
          width: 220 * scaleX,
          height: 220 * scaleY,
        ),
      ),
      // Заголовок "Оформи подписку"
      Positioned(
        top: 298 * scaleY,
        left: 16 * scaleX,
        child: SizedBox(
          width: 230 * scaleX,
          height: 38 * scaleY,
          child: Text(
            "Оформи подписку",
            style: TextStyle(
              fontFamily: 'Jost',
              fontWeight: FontWeight.w700,
              fontSize: 26 * scaleX,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // Промо-текст
      Positioned(
        top: 346 * scaleY,
        left: 16 * scaleX,
        child: SizedBox(
          width: 389 * scaleX,
          height: 100 * scaleY,
          child: Text(
            "И размещай вакансии в приложении “MamaKris”.\n\n"
                "У нас одна из самых больших баз соискателей.\n"
                "С нами вы легко найдете сотрудника для удаленной работы в своей проект. Успехов!",
            style: TextStyle(
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,
              fontSize: 14 * scaleX,
              height: 20 / 14,
              letterSpacing: -0.1 * scaleX,
              color: const Color(0xFF596574),
            ),
          ),
        ),
      ),
      // Первая кнопка: "Разовое размещение вакансии" и "499 ₽"
      Positioned(
        top: 466 * scaleY,
        left: 16 * scaleX,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedSubscription = SubscriptionType.oneTime;
            });
          },
          child: Container(
            width: 190 * scaleX,
            height: 178 * scaleY,
            padding: EdgeInsets.only(
              left: 24 * scaleX,
              top: 24 * scaleY,
              right: 24 * scaleX,
              bottom: 24 * scaleY,
            ),
            decoration: BoxDecoration(
              color: selectedSubscription == SubscriptionType.oneTime
                  ? const Color(0xFF00A80E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15 * scaleX),
              boxShadow: [
                BoxShadow(
                  color: selectedSubscription == SubscriptionType.oneTime
                      ? const Color(0xFFCFFFD1)
                      : const Color(0x78E7E7E7),
                  offset: Offset(0, 4 * scaleY),
                  blurRadius: 19 * scaleX,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Текст выровнен по левому краю
                Text(
                  "Разовое размещение вакансии",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 18 * scaleX,
                    height: 20 / 18,
                    letterSpacing: -0.18 * scaleX,
                    color: selectedSubscription == SubscriptionType.oneTime
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 25 * scaleY),
                // Текст цены с отступом слева 25
                Text(
                  "499 ₽",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 26 * scaleX,
                    height: 28 / 26,
                    letterSpacing: -0.26 * scaleX,
                    color: selectedSubscription == SubscriptionType.oneTime
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Вторая кнопка: "Годовая подписка" с дополнительными текстами
      Positioned(
        top: 466 * scaleY,
        left: 222 * scaleX,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedSubscription = SubscriptionType.annual;
            });
          },
          child: Container(
            width: 190 * scaleX,
            height: 208 * scaleY,
            padding: EdgeInsets.only(
              left: 18 * scaleX,
              top: 18 * scaleY,
              right: 14 * scaleX,
              bottom: 18 * scaleY,
            ),
            decoration: BoxDecoration(
              color: selectedSubscription == SubscriptionType.annual
                  ? const Color(0xFF00A80E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15 * scaleX),
              boxShadow: [
                BoxShadow(
                  color: selectedSubscription == SubscriptionType.annual
                      ? const Color(0xFFCFFFD1)
                      : const Color(0x78E7E7E7),
                  offset: Offset(0, 4 * scaleY),
                  blurRadius: 19 * scaleX,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Годовая подписка",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 18 * scaleX,
                    height: 20 / 18,
                    letterSpacing: -0.18 * scaleX,
                    color: selectedSubscription == SubscriptionType.annual
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 8 * scaleY),
                Text(
                  "на год с безлимитным размещением вакансий",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * scaleY,
                    height: 20 / 14,
                    letterSpacing: 0,
                    color: selectedSubscription == SubscriptionType.annual
                        ? Colors.white
                        : const Color(0xFF596574),
                  ),
                ),
                SizedBox(height: 8 * scaleY),
                Text(
                  "2 999 ₽",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 26 * scaleX,
                    height: 28 / 26,
                    letterSpacing: -0.26 * scaleX,
                    color: selectedSubscription == SubscriptionType.annual
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 8 * scaleY),
                Text(
                  "249 ₽/месяц",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 14 * scaleX,
                    height: 20 / 14,
                    letterSpacing: -0.14 * scaleX,
                    color: selectedSubscription == SubscriptionType.annual
                        ? Colors.white
                        : const Color(0xFF596574),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Кастомный чекбокс
      Positioned(
        top: 704 * scaleY,
        left: 32 * scaleX,
        child: CustomCheckbox(
          initialValue: agreeTerms,
          onChanged: (bool value) {
            setState(() {
              agreeTerms = value;
            });
          },
          scaleX: scaleX,
          scaleY: scaleY,
        ),
      ),
      // // Текст соглашения
      // Positioned(
      //   top: 694 * scaleY,
      //   left: 61 * scaleX,
      //   child: SizedBox(
      //     width: 252 * scaleX,
      //     height: 60 * scaleY,
      //     child: Text(
      //       "Согласен с Условиями подписки\nи Политикой конфиденциальности",
      //       style: TextStyle(
      //         fontFamily: 'Jost',
      //         fontWeight: FontWeight.w400,
      //         fontSize: 14 * scaleX,
      //         height: 20 / 14,
      //         letterSpacing: -0.1 * scaleX,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // ),
      // Чекбокс + RichText с двумя кликабельными ссылками
      Positioned(
        top: 694 * scaleY,
        left: 61 * scaleX,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 252 * scaleX,
              height: 60 * scaleY,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * scaleX,
                    height: 20 / 14,
                    letterSpacing: -0.1 * scaleX,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Согласен с '),
                    TextSpan(
                      text: 'Условиями подписки',
                      style: const TextStyle(
                        color: Color(0xFF00A80E),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 300),
                              pageBuilder: (_, animation, __) =>
                              const LicenseScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                final tween = Tween(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                                return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child);
                              },
                            ),
                          );
                        },
                    ),
                    const TextSpan(text: '\nи '),
                    TextSpan(
                      text: 'Политикой конфиденциальности',
                      style: const TextStyle(
                        color: Color(0xFF00A80E),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 300),
                              pageBuilder: (_, animation, __) =>
                              const ConfScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                final tween = Tween(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                                return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child);
                              },
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Кнопка перехода (с динамическим текстом)
      Positioned(
        top: 754 * scaleY,
        left: 16 * scaleX,
        child: GestureDetector(
          onTap: () {
            if (agreeTerms) {
              _onProceedButtonPressed();
            } else {
              // debugPrint("Необходимо согласиться с условиями подписки");
            }
          },
          child: Container(
            width: 396 * scaleX,
            height: 68 * scaleY,
            padding: EdgeInsets.fromLTRB(
              24 * scaleX,
              20 * scaleY,
              24 * scaleX,
              20 * scaleY,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF00A80E),
              borderRadius: BorderRadius.circular(15 * scaleX),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCFFFD1),
                  offset: Offset(0, 4 * scaleY),
                  blurRadius: 19 * scaleX,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                selectedSubscription == SubscriptionType.oneTime
                    ? "Разместить за 499 ₽"
                    : "Подписаться за 249 ₽/месяц",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w600,
                  fontSize: 18 * scaleX,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 834 * scaleY,
        left: 16 * scaleX,
        child: Container(
          width: 396 * scaleX,
          height: 72 * scaleY,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0x78E7E7E7),
                offset: Offset(0, 4 * scaleY),
                blurRadius: 19 * scaleX,
              ),
            ],
            borderRadius: BorderRadius.circular(15 * scaleX),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, animation, secondaryAnimation) =>
                  const MainScreen(initialIndex: 1),
                  transitionsBuilder: (_, animation, __, child) {
                    final tween = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
                    (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15 * scaleX),
              ),
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: 20 * scaleY,
                horizontal: 24 * scaleX,
              ),
            ),
            child: Center(
              child: Text(
                'Назад',
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
          ),
        ),
      ),

    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: children,
      ),
    );
  }
}