import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class ApplProfileEditScreen extends StatefulWidget {
  const ApplProfileEditScreen({super.key});

  @override
  _ApplProfileEditScreenState createState() => _ApplProfileEditScreenState();
}

class _ApplProfileEditScreenState extends State<ApplProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Редактирование профиля'),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: const SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          _basicInformation(),
                          SizedBox(height: 20),

                          // Контакты -- Contacts
                          _Contacts(),
                          SizedBox(height: 20),

                          /// Специализация -- Speciliasaton
                          _accounts(),
                          SizedBox(height: 20),

                          CustomButtonApplicant(btnText: 'Сохранить изменения'),
                          SizedBox(height: 32),

                          /// Опыт работы-- Experience
                        ],
                      ),
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

class _basicInformation extends StatelessWidget {
  const _basicInformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Основная информация',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'Гордова',
            labelText: "Фамилия",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'Кристина',
            labelText: "Имя",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: '23.08.1999',
            labelText: "Дата рождения",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'MamaKris@gmail.com',
            labelText: "Почта",
            controller: TextEditingController(),
          ),
          CustomInputText(
            hintText: '+79997773322',
            labelText: "Номер телефона",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Контакты',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'Telegram',
            labelText: "Как с вами связаться?",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: '******',
            labelText: "Ссылка",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'VK',
            labelText: "Как с вами связаться?",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: '*****',
            labelText: "Ссылка",
            controller: TextEditingController(),
          ),
          CustomInputText(
            hintText: '+79997773322',
            labelText: "Номер телефона",
            controller: TextEditingController(),
          ),

          const SizedBox(height: 16),
          const _updateButtons(),
        ],
      ),
    );
  }
}

class _accounts extends StatefulWidget {
  const _accounts();

  @override
  State<_accounts> createState() => _AccountsState();
}

class _AccountsState extends State<_accounts> {
  bool _acceptOrders =
      false; // Default to false, can be loaded from preferences or API

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Аккаунт',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Принимать заказы',
                style: TextStyle(
                  color: Color(0xFF596574),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                ),
              ),
              const Spacer(),
              Switch(
                value: _acceptOrders,
                onChanged: (bool value) {
                  setState(() {
                    _acceptOrders = value;
                  });
                  // TODO: Save the preference to backend or local storage
                },
                activeThumbColor: AppPalette.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _updateButtons(text: "Управление подпиской"),
          const SizedBox(height: 16),
          const _updateButtons(text: "Управление подпиской", error: true),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _updateButtons extends StatelessWidget {
  const _updateButtons({
    this.text = 'Добавить контакт',
    this.error = false,
  });
  final String text;
  final bool error;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: error
              ? const BorderSide(color: AppPalette.error)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x332E7866),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 30,
        children: [
          Text(
            text,
            style: TextStyle(
              color: error ? AppPalette.error : const Color(0xFF2E7866),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),

          if (error)
            const CustomImageView(imagePath: MediaRes.deleteIcon, width: 24),
        ],
      ),
    );
  }
}
