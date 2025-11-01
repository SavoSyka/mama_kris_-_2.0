import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class EmpProfileEditScreen extends StatefulWidget {
  const EmpProfileEditScreen({super.key});

  @override
  _EmpProfileEditScreenState createState() => _EmpProfileEditScreenState();
}

class _EmpProfileEditScreenState extends State<EmpProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Редактированиепрофиля'),

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

                          CustomButtonEmployee(btnText: 'Сохранить изменения'),
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
            hasGreyBg: true,
            readOnly: true,
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
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(MediaRes.dropDownIcon, width: 16),
            ),
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
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(MediaRes.dropDownIcon, width: 16),
            ),
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
  final bool _acceptOrders =
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

          const _updateButtons(text: "Управление подпиской"),

          const SizedBox(height: 16),
          _updateButtons(
            text: "Выйти из аккаунта",
            error: true,
            errorIcon: MediaRes.logoutIcon,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _updateButtons(
            text: "Управление подпиской",
            error: true,
            onTap: () {},
          ),

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
    this.errorIcon,

    this.onTap,
  });
  final String text;
  final bool error;
  final String? errorIcon;

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                color: error ? AppPalette.error : AppPalette.empPrimaryColor,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),

            if (error)
              CustomImageView(
                imagePath: errorIcon ?? MediaRes.deleteIcon,
                width: 24,
              ),
          ],
        ),
      ),
    );
  }
}
