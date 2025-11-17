import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_phone_picker.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_edit_basic_info.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_edit_work_experience.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/appl_contact_widget.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/appl_work_experience_widget.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/widget/show_delete_icon_dialog.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/widget/show_logout_dialog.dart';

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
      appBar: const CustomAppBar(title: 'Редактированиепрофиля'),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          _basicInformation(),
                          const SizedBox(height: 20),

                          // Контакты -- Contacts
                          const ApplContactWidget(),
                          const SizedBox(height: 20),

                          const ApplWorkExperienceWidget(),
                          const SizedBox(height: 20),

                          /// Специализация -- Speciliasaton
                          const _accounts(),
                          const SizedBox(height: 20),

                          // CustomButtonApplicant(
                          //   btnText: 'Сохранить изменения',
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //   },
                          // ),
                          const SizedBox(height: 32),

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
  _basicInformation();
  String? name;
  String? email;
  String? dob;

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      name = userState.user.name;
      dob = userState.user.birthDate;
      email = userState.user.email;
    }

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
            controller: TextEditingController(text: name),
            readOnly: true,
          ),

          const SizedBox(height: 8),

          CustomInputText(
            hintText: '',
            labelText: "Дата рождения",
            controller: TextEditingController(text: dob),
            readOnly: true,
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'MamaKris@gmail.com',
            labelText: "Почта",
            controller: TextEditingController(text: email),
            readOnly: true,
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ApplProfileEditBasicInfo(),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.pen, color: Colors.white, size: 18),
            label: const Text(
              "Добавить опыт работы",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primaryColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          // CustomInputText(
          //   hintText: '+79997773322',
          //   labelText: "Номер телефона",
          //   controller: TextEditingController(),
          // ),
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
          const SizedBox(height: 16),

          // Row(
          //   children: [
          //     const Text(
          //       'Принимать заказы',
          //       style: TextStyle(
          //         color: Color(0xFF596574),
          //         fontSize: 16,
          //         fontFamily: 'Manrope',
          //         fontWeight: FontWeight.w500,
          //         height: 1.30,
          //       ),
          //     ),
          //     const Spacer(),
          //     Switch(
          //       value: _acceptOrders,
          //       onChanged: (bool value) {
          //         setState(() {
          //           _acceptOrders = value;
          //         });
          //         // TODO: Save the preference to backend or local storage
          //       },
          //       activeThumbColor: AppPalette.primaryColor,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 16),
          _updateButtons(
            text:
                "Manage Subscription", //"Управление подпиской", // manage subscription
            onTap: () {
              context.pushNamed(RouteName.subscription);
            },
          ),
          const SizedBox(height: 16),

          _updateButtons(
            text: "Выйти из аккаунта",
            error: true,
            errorIcon: MediaRes.logoutIcon,
            onTap: () {
              showLogoutDialog(context, isApplicant: true, () {
                print("Account logout");
                context.pushNamed(RouteName.welcomePage);
              });
            },
          ),
          const SizedBox(height: 16),
          BlocConsumer<ApplicantContactBloc, ApplicantContactState>(
            listener: (context, state) {
              if (state is AccountDeleteLoadingState) {
                showIOSLoader(context);
              } else if (state is UserAccountDeleted) {
                Navigator.pop(context);
                context.pushNamed(RouteName.welcomePage);
              }
              // TODO: implement listener
            },
            builder: (context, state) {
              return _updateButtons(
                text: "Управление подпиской",
                error: true,

                onTap: () {
                  showDeleteAccountDialog(context, () {
                    print("Account deleted");

                    context.read<ApplicantContactBloc>().add(
                      const DeleteUserAccountEvent(),
                    );
                    // context.pushNamed(RouteName.welcomePage);
                  });
                  // context.pushNamed(RouteName.welcomePage);
                },
              );
            },
          ),

          // delete
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
    this.onTap,
    this.errorIcon,
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
                color: error ? AppPalette.error : const Color(0xFF2E7866),
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
