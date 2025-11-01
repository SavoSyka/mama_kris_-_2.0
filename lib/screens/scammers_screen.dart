import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScammersScreen extends StatelessWidget {
  const ScammersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Расчёт коэффициентов масштабирования (базовый макет 428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    // Общая высота контейнера (для прокрутки)
    final double contentHeight = (151 + 1060) * scaleY;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: contentHeight,
          child: Stack(
            children: [
              // Зелёный блюр‑фон с плавным градиентом
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
              // Title.svg
              Positioned(
                top: 75 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 225 * scaleX,
                  child: Text(
                    "Как защититься от мошенников?",
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
              // Description.png (фон описания)
              Positioned(
                top: 151 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  child: Text(
                    '''Поиск удалённой работы открывает массу возможностей, но, к сожалению, привлекает и мошенников. Наша команда HR-менеджеров пропускает все вакансии через собственный фильтр, но, к сожалению, стопроцентной гарантии дать всё равно не может. Мы отбираем для вас лучшие предложения по удалённой работе, но ответственности за недобросовестных работодателей не несём. Именно поэтому мы написали эту статью, чтобы лишний раз обезопасить вас.

Чтобы защитить себя, следуйте этим советам:

Будьте скептичны к слишком хорошим предложениям: Если вакансия обещает огромную зарплату за минимальные усилия или не требует опыта, это должно насторожить. Мошенники часто используют подобные уловки.
Не платите за работу: Легитимные работодатели никогда не берут деньги за предоставление работы.
Никому не сообщайте пароли от аккаунтов iCloud, App Store, iMessage и электронных почт. Также ни в коем случае не сообщайте данные из SMS-сообщений.
Не раскрывайте лишнюю личную информацию: Не делитесь паспортными данными, номерами банковских карт и другой конфиденциальной информацией, пока не убедитесь в надёжности работодателя.
Будьте осторожны с просьбами о помощи в финансовых вопросах: Если работодатель просит переводить деньги на его счёт или использовать ваши банковские реквизиты для сомнительных операций, это явный признак мошенничества.
Не отправляйте оригиналы документов по электронной почте: Если вас просят отправить скан паспорта или другие оригиналы документов, откажитесь. Достаточно предоставить копии.

Еще раз подчеркнем: мы делаем всё, чтобы на нашей платформе не было вакансий от мошенников. Но мошенники бывают очень хитры и изобретательны. Поэтому мы делимся с вами этой статьей. Ответственность за добросовестность и надёжность работодателей МЫ НЕ НЕСЁМ!

Наша платформа — это лишь агрегатор, помогающий соискателям и работодателям найти друг друга. Мы пропускаем вакансии через фильтр, чтобы упростить ваш поиск, но защитить вас на сто процентов, увы, не можем. Поэтому будьте сами внимательны и осторожны!''',
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
              Positioned(
                top: 1080 * scaleY,
                left: 16 * scaleX,
                child: Container(
                  width: 396 * scaleX,
                  height: 72 * scaleY,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCFFFD1),
                        offset: Offset(0, 4 * scaleY),
                        blurRadius: 19 * scaleX,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15 * scaleX),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A80E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15 * scaleX,
                        ),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: 20 * scaleY,
                        horizontal: 24 * scaleX,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Назад',
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w600,
                              fontSize: 18 * scaleX,
                              height: 28 / 18,
                              letterSpacing: -0.18 * scaleX,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10 * scaleX),
                        SvgPicture.asset(
                          'assets/welcome_screen/arrow.svg',
                          width: 32 * scaleX,
                          height: 32 * scaleY,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
