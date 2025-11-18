import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/build_error_card.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/emp_profile_edit_screen.dart';

class EmpProfileScreen extends StatefulWidget {
  const EmpProfileScreen({super.key});

  @override
  _EmpProfileScreenState createState() => _EmpProfileScreenState();
}

class _EmpProfileScreenState extends State<EmpProfileScreen> {
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
              context.pushNamed(RouteName.editProfileEmployee);
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
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          child: BlocBuilder<EmpUserBloc, EmpUserState>(
            builder: (context, state) {
              if (state is EmpUserLoading) {
                return const Row(
                  children: [Expanded(child: IPhoneLoader(height: 200))],
                );
              } else if (state is EmpUserError) {
                return BuildErrorCard(message: state.message);
              } else if (state is EmpUserLoaded) {
                final user = state.user;

                return Column(
                  children: [
                    Expanded(
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
                              const _Contacts(),
                              const SizedBox(height: 20),

                              /// Специализация -- Speciliasaton
                              const _Specalisations(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
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
                  'Проверенный работодатель',
                  style: TextStyle(
                    color: AppPalette.empPrimaryColor,
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$name',
                style: const TextStyle(
                  color: AppPalette.empPrimaryColor,

                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Компания:  GordovCode ',
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Описание моей деятельности',
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
              Expanded(
                child: Text(
                  'Я руковожу компанией среднего масштаба, которая уже несколько лет стабильно работает на рынке. Для меня важно сочетать устойчивость и развитие: мы не гонимся за быстрыми результатами, а строим долгосрочные отношения с клиентами и партнёрами. Основное внимание уделяю качеству услуг и оптимизации процессов, чтобы команда могла работать эффективно, а клиенты видели в нас надёжного партнёра.',
                  style: TextStyle(
                    color: Color(0xFF596574),
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
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
