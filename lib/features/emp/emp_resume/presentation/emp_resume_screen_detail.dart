import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

class EmpResumeScreenDetail extends StatefulWidget {
  const EmpResumeScreenDetail({super.key});

  @override
  _EmpResumeScreenDetailState createState() => _EmpResumeScreenDetailState();
}

class _EmpResumeScreenDetailState extends State<EmpResumeScreenDetail> {
  final GlobalKey _menuKey = GlobalKey();

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: '',
        alignTitleToEnd: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: AppTheme.cardDecoration.copyWith(
                borderRadius: BorderRadius.circular(8),
                border: isLiked
                    ? Border.all(color: Theme.of(context).primaryColor)
                    : null,
              ),
              child: const CustomImageView(
                imagePath: MediaRes.star,
                width: 20,
                height: 20,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tooltip: 'Настройки',
            splashRadius: 24,
          ),
          IconButton(
            onPressed: () {
              _showJobOptionsMenu(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: AppTheme.cardDecoration.copyWith(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomImageView(
                imagePath: MediaRes.verticalDots,
                width: 20,
                height: 20,
              ),
            ),
            key: _menuKey,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tooltip: 'Настройки',
            splashRadius: 24,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
                    decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: const SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    child: Column(
                      children: [
                        // Принимает заказы -- Accept Orders
                        _AcceptOrders(),
                        SizedBox(height: 20),

                        // Контакты -- Contacts
                        _Contacts(),
                        SizedBox(height: 20),

                        /// Специализация -- Speciliasaton
                        _Specalisations(),
                        SizedBox(height: 20),

                        /// Опыт работы-- Experience
                        _Experiences(),
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

  void _showJobOptionsMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            // Handle add to favorites
          },
          child: const Text('В избранное'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle share
            Share.share('Check out this job: ', subject: 'Job Opportunity');
          },
          child: const Text('Отправить жалобу'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report
          },
          child: const Text('Скрыть', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class _AcceptOrders extends StatelessWidget {
  const _AcceptOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ///  Rounded Chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: AppPalette.empPrimaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Принимает заказы',
                  style: TextStyle(
                    color: Color(0xFF2E7866),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Кристина Гордова',
                style: TextStyle(
                  color: AppPalette.empPrimaryColor,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                '23.08.1999 (26 лет)',
                style: TextStyle(
                  color: AppPalette.greyDark,

                  fontSize: 12,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Contacts extends StatelessWidget {
  const _Contacts();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Контакты',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),

              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.email, color: AppPalette.empPrimaryColor),
                  SizedBox(width: 16),
                  Text(
                    'MamaKris@gmail.com',
                    style: TextStyle(
                      color: Color(0xFF596574),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      height: 1.30,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.phone, color: AppPalette.empPrimaryColor),
                  SizedBox(width: 16),
                  Text(
                    '+79997773322',
                    style: TextStyle(
                      color: Color(0xFF596574),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      height: 1.30,
                    ),
                  ),
                ],
              ),

              // * Telegram, VK, whatsapp action cards -- left
            ],
          ),
        ],
      ),
    );
  }
}

class _Specalisations extends StatelessWidget {
  const _Specalisations();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Column(
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

              Row(
                spacing: 8,
                children: [
                  _specialisationItem("Дизайнер"),
                  _specialisationItem("Маркетолог"),
                  _specialisationItem("Ассистент"),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                spacing: 8,
                children: [
                  _specialisationItem("Видеомонтаж"),
                  _specialisationItem("Контекстная реклама"),
                ],
              ),
            ],
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
          side: const BorderSide(width: 1, color: AppPalette.empPrimaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }
}

class _Experiences extends StatelessWidget {
  const _Experiences();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Опыт работы',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),

          const SizedBox(height: 24),
          _expereinceItems(
            title: "Creative Agency «PixelCraft»",
            position: "Дизайнер",
            datePeriod: "12.09.2023 - 11.12.2025",
          ),
          const SizedBox(height: 12),

          _expereinceItems(
            title: "Creative Agency «PixelCraft»",
            position: "Дизайнер",
            datePeriod: "12.09.2023 - 11.12.2025",
          ),
          const SizedBox(height: 12),

          _expereinceItems(
            title: "Creative Agency «PixelCraft»",
            position: "Дизайнер",
            datePeriod: "12.09.2023 - 11.12.2025",
          ),
          const SizedBox(height: 12),

          _expereinceItems(
            title: "Creative Agency «PixelCraft»",
            position: "Дизайнер",
            datePeriod: "12.09.2023 - 11.12.2025",
          ),
        ],
      ),
    );
  }

  Widget _expereinceItems({
    required String title,
    required String position,
    required String datePeriod,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x7F2E7866)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            position,
            style: const TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            datePeriod,
            style: const TextStyle(
              color: Color(0xFF596574),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              height: 1.30,
            ),
          ),
        ],
      ),
    );
  }
}
