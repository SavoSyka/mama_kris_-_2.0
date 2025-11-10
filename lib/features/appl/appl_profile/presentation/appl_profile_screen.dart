import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_edit_screen.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';

class ApplProfileScreen extends StatefulWidget {
  const ApplProfileScreen({super.key});

  @override
  _ApplProfileScreenState createState() => _ApplProfileScreenState();
}

class _ApplProfileScreenState extends State<ApplProfileScreen> {
  // * ────────────── Override methods ───────────────────────
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // * ────────────── BUILD UI ───────────────────────

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Мой профиль',
        showLeading: false,
        alignTitleToEnd: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApplProfileEditScreen(),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: AppTheme.cardDecoration.copyWith(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomImageView(
                imagePath: MediaRes.settingGearIcon,
                width: 24,
                height: 24,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tooltip: 'Настройки',
            splashRadius: 24,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Row(
                      children: [Expanded(child: IPhoneLoader(height: 200))],
                    );
                  } else if (state is UserError) {
                    return Expanded(
                      child: Container(
                        color: Colors.blue,

                        child: Container(
                          color: Colors.red,
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Center(
                              child: CustomDefaultPadding(
                                child: Column(
                                  children: [
                                    CustomErrorRetry(
                                      errorMessage: state.message,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is UserLoaded) {
                    final user = state.user;
                    return Expanded(
                      child: SingleChildScrollView(
                        child: CustomDefaultPadding(
                          child: Column(
                            children: [
                              // Принимает заказы -- Accept Orders
                              _AcceptOrders(
                                name: user.name,
                                birthDate: user.birthDate,
                              ),
                              const SizedBox(height: 20),
                      
                              // Контакты -- Contacts
                              _Contacts(email: user.email, phone: user.phone),
                              const SizedBox(height: 20),
                      
                              /// Специализация -- Speciliasaton
                              const _Specalisations(),
                              const SizedBox(height: 20),
                      
                              /// Опыт работы-- Experience
                              const _Experiences(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Text("sttate ${state.runtimeType}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcceptOrders extends StatelessWidget {
  const _AcceptOrders({this.name, this.birthDate});
  final String? name;
  final String? birthDate;

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
                      color: AppPalette.primaryColor,
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
              Text(
                "$name",
                style: const TextStyle(
                  color: AppPalette.primaryColor,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                '$birthDate (26 лет)',
                style: const TextStyle(
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
  const _Contacts({this.email, this.phone});
  final String? email;
  final String? phone;

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
                'Контакты',
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
                children: [
                  const Icon(Icons.email, color: AppPalette.primaryColor),
                  const SizedBox(width: 16),
                  Text(
                    "$email",
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

              if (phone != null && phone!.isNotEmpty) ...[
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.phone, color: AppPalette.primaryColor),
                    const SizedBox(width: 16),
                    Text(
                      "$phone",

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
              ],
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
          side: const BorderSide(width: 1, color: Color(0x7F2E7866)),
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
              color: Color(0xFF2E7866),
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
              color: AppPalette.primaryColor,
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
