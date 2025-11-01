import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Расчёт коэффициентов масштабирования (базовый макет 428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleX = screenWidth / 428;
    final double scaleY = screenHeight / 956;

    // Общая высота контейнера (для прокрутки)
    final double contentHeight = (151 + 4000) * scaleY;

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
                  width: 300 * scaleX,
                  child: Text(
                    "Как пользоваться приложением?",
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
                  height: 540 * scaleY,
                  child: Text(
                    "Добро пожаловать в удобный сервис удалённой работы!\n\n"
                    "Меня зовут Кристина — создатель и руководитель it-проекта MamaKris. Я многодетная мама с 12-летним опытом работы онлайн, и я знаю, как сложно найти проверенные вакансии и надёжных исполнителей.\n\n"
                    "Биржи фриланса берут огромные комиссии, а чаты в Telegram переполнены спамом.\n\n"
                    "Поэтому я создала платформу, где:\n"
                    "✔️ Только проверенные вакансии – их отбирают HR-специалисты и ИИ.\n"
                    "✔️ Простота и удобство – никакой лишней информации, только актуальные предложения.\n"
                    "✔️ Безопасность – минимум сомнительных заказов.\n\n"
                    "Как это работает?\n\n"
                    "В приложении две роли:\n"
                    "🔹 Исполнитель – ищет работу.\n"
                    "🔹 Работодатель – размещает вакансии.",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // SVG-картинка 1
              Positioned(
                top: 691 * scaleY,
                left: 68 * scaleX,
                child: SizedBox(
                  width: 292 * scaleX,
                  height: 351 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image1.svg', // замените на ваш asset
                    width: 292 * scaleX,
                    height: 351 * scaleY,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Текст: "1. Для исполнителей"
              Positioned(
                top: 1102 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 40 * scaleY,
                  child: Text(
                    "1. Для исполнителей",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w700,
                      fontSize: 28 * scaleX,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Текст: "📌 Шаг 1. Выберите роль «Исполнитель» и заполните анкету. 📌 Шаг 2. В данной роли можно выбрать помощь от карьерного консультанта или психолога."
              Positioned(
                top: 1150 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 80 * scaleY,
                  child: Text(
                    "📌 Шаг 1. Выберите роль «Исполнитель» и заполните анкету.\n📌 Шаг 2. В данной роли можно выбрать помощь от карьерного консультанта или психолога.",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // SVG-картинка 2
              Positioned(
                top: 1250 * scaleY,
                left: 67 * scaleX,
                child: SizedBox(
                  width: 292 * scaleX,
                  height: 350 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image2.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Текст: "📌 Шаг 3. Лайкайте понравившиеся предложения в разделе главная – контакты работодателя откроются автоматически."
              Positioned(
                top: 1620 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 50 * scaleY,
                  child: Text(
                    "📌 Шаг 3. Лайкайте понравившиеся предложения в разделе главная – контакты работодателя откроются автоматически.",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // SVG-картинка 3
              Positioned(
                top: 1680 * scaleY,
                left: 68 * scaleX,
                child: SizedBox(
                  width: 292 * scaleX,
                  height: 404 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image3.svg', // замените на ваш asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Текст: "📌 Шаг 4. Вакансия сохранится в «Мои заказы» на 10 дней – успейте связаться!"
              Positioned(
                top: 2104 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 50 * scaleY,
                  child: Text(
                    "📌 Шаг 4. Вакансия сохранится в «Мои заказы» на 10 дней – успейте связаться!",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // SVG-картинка 4
              Positioned(
                top: 2164 * scaleY,
                left: 68 * scaleX,
                child: SizedBox(
                  width: 292 * scaleX,
                  height: 319 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image4.svg', // замените на ваш asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
// Текст: "Важно! – Мы отбираем лучшие удаленные вакансии для Вас из интернета, но не отвечаем за ваши договорённости с работодателем. Поэтому рекомендуем прочитать статью «Как защититься от мошенников» в разделе Поддержка."
              Positioned(
                top: 2503 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 100 * scaleY,
                  child: Text(
                    "Важно! – Мы отбираем лучшие удаленные вакансии для Вас из интернета, но не отвечаем за ваши договорённости с работодателем. Поэтому рекомендуем прочитать статью «Как защититься от мошенников» в разделе Поддержка.",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Positioned(
                top: 2663 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 382 * scaleX,
                  height: 40 * scaleY,
                  child: Text(
                    "2. Для работодателей",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w700,
                      fontSize: 28 * scaleX,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2711 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 60 * scaleY,
                  child: Text(
                    "📌 Шаг 1. Выберите роль «Работодатель» и создайте вакансию.  ",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // SVG-картинка 5
              Positioned(
                top: 2771 * scaleY,
                left: 68 * scaleX,
                child: SizedBox(
                  width: 292 * scaleX,
                  height: 351 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image5.svg', // замените на ваш asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 3132 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 40 * scaleY,
                  child: Text(
                    "📌 Шаг 2. Наши модераторы проверят её, и она появится в ленте исполнителей.  ",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),

              // Текст: "Навигация в приложении: ... (много строк)"
              Positioned(
                top: 3247 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 420 * scaleX,
                  height: 40 * scaleY,
                  child: Text(
                    "Навигация в приложении",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w700,
                      fontSize: 28 * scaleX,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 3295 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 255 * scaleY,
                  child: Text(
                    '''Внизу экрана – удобное меню:

🏠 Главная – свежие вакансии.  

📋 Мои заказы – сохранённые предложения.  

🛟 Поддержка – техпомощь, реклама, карьерные консультации и психологи.  

👤 Профиль – смена роли, настройки, подписка.  ''',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Positioned(
                top: 3555 * scaleY,
                left: 15.42 * scaleX,
                child: SizedBox(
                  width: 397.16 * scaleX,
                  height: 79 * scaleY,
                  child: SvgPicture.asset(
                    'assets/usage_screen/image6.svg', // замените на ваш asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Текст: "💡 Совет: Откликайтесь на 30-50 вакансий в день, активно общайтесь с работодателями в мессенджерах – и вы быстро найдёте работу мечты!"
              Positioned(
                top: 3674 * scaleY,
                left: 16 * scaleX,
                child: SizedBox(
                  width: 396 * scaleX,
                  height: 80 * scaleY,
                  child: Text(
                    "💡 Совет: Откликайтесь на 30-50 вакансий в день, активно общайтесь с работодателями в мессенджерах – и вы быстро найдёте работу мечты!",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              // Текст: "«MamaKris» делает поиск удалённой работы простым и безопасным."
              Positioned(
                top: 3804 * scaleY,
                left: 68 * scaleX,
                child: SizedBox(
                  width: 291 * scaleX,
                  height: 60 * scaleY,
                  child: Text(
                    "«MamaKris» делает поиск удалённой работы простым и безопасным.",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Текст: "С уважением,  Команда проекта"
              Positioned(
                top: 3874 * scaleY,
                left: 140 * scaleX,
                child: SizedBox(
                  width: 150 * scaleX,
                  height: 60 * scaleY,
                  child: Text(
                    "С уважением,  Команда проекта",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Текст: "P.S. Если у вас есть вопросы – пишите в Поддержку, мы всегда на связи!"
              Positioned(
                top: 3964 * scaleY,
                left: 41 * scaleX,
                child: SizedBox(
                  width: 345 * scaleX,
                  height: 60 * scaleY,
                  child: Text(
                    "P.S. Если у вас есть вопросы – пишите в Поддержку, мы всегда на связи!",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w400,
                      fontSize: 14 * scaleX,
                      height: 20 / 14,
                      letterSpacing: -0.1 * scaleX,
                      color: const Color(0xFF596574),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 4050 * scaleY,
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
