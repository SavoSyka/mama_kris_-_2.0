import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_with.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/build_error_card.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
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
      appBar: CustomAppBarWithActions(
        title: 'Мой профиль',
        showLeading: false,
        alignTitleToEnd: false,
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed(RouteName.editProfileEmployee);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: AppTheme.cardDecoration.copyWith(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomImageView(
                imagePath: MediaRes.gearIcon,
                width: 28,
                height: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                              if (user.contacts?.isNotEmpty ?? false)
                                _Contacts(contact: user.contacts!.last),
                              const SizedBox(height: 20),

                              /// Специализация -- Speciliasaton
                              if (user.about != null)
                                _AboutEmployee(about: user.about as String),
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
            ],
          ),
        ],
      ),
    );
  }
}

class _Contacts extends StatelessWidget {
  const _Contacts({required this.contact});
  final ContactEntity contact;

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
              if (contact.email?.isNotEmpty ?? false)
                Row(
                  children: [
                    const Icon(Icons.email, color: AppPalette.empPrimaryColor),
                    const SizedBox(width: 16),
                    Text(
                      contact.email!,
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

              const SizedBox(height: 8),
              if (contact.phone?.isNotEmpty ?? false)
                Row(
                  children: [
                    const Icon(Icons.phone, color: AppPalette.empPrimaryColor),
                    const SizedBox(width: 16),
                    Text(
                      contact.phone!,
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

              // * Telegram, VK, whatsapp action cards -- left
              Row(
                spacing: 12,
                children: [
                  _buildSocialContact(
                    onTap: () {},
                    icon: MediaRes.telegramIcon,
                  ),

                  _buildSocialContact(onTap: () {}, icon: MediaRes.vkIcon),
                  _buildSocialContact(
                    onTap: () {},
                    icon: MediaRes.whatsappIcon,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialContact({
    required VoidCallback onTap,
    required String icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: AppPalette.empPrimaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Image.asset(icon, width: 24),
        ),
      ),
    );
  }
}

class _AboutEmployee extends StatelessWidget {
  const _AboutEmployee({required this.about});
  final String about;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Описание моей деятельности',
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
              Expanded(
                child: Text(
                  about,
                  style: const TextStyle(
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
