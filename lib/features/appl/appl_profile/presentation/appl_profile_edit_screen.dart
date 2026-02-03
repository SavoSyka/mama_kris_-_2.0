import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_specialisation.dart';
import 'package:mama_kris/core/common/widgets/custom_static_input.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/auth/auth_service.dart';
import 'package:mama_kris/core/services/lifecycle/bloc/life_cycle_manager_bloc.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/add_specialisation_modal.dart.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/appl_contact_widget.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/widget/appl_work_experience_widget.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/core/common/widgets/show_delete_icon_dialog.dart';
import 'package:mama_kris/core/common/widgets/show_logout_dialog.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/core/common/widgets/custom_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplProfileEditScreen extends StatefulWidget {
  const ApplProfileEditScreen({super.key});

  @override
  _ApplProfileEditScreenState createState() => _ApplProfileEditScreenState();
}

class _ApplProfileEditScreenState extends State<ApplProfileEditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();
  }

  UserProfileEntity? _userState;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Редактирование профиля'),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          bottom: false,
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              debugPrint("boom aree arupd");

              if (state is UserLoaded) {
                debugPrint("we aree arupd");
                setState(() {
                  _userState = state.user;
                });
              }
              // TODO: implement listener
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: CustomDefaultPadding(
                          bottom: 0,
                          child: Column(
                            children: [
                              // Основная информация -- basic information
                              const _basicInformation(),
                              const SizedBox(height: 20),

                              // Контакты -- Contacts
                              const ApplContactWidget(),
                              const SizedBox(height: 20),

                              const ApplWorkExperienceWidget(),
                              const SizedBox(height: 20),

                              /// Специализация -- Speciliasaton
                              CustomSpecialisation(
                                specializations:
                                    _userState?.specializations ?? [],
                                onTap: () async {
                                  final result = await AddSpecialisationModal(
                                    context,
                                    speciality:
                                        _userState?.specializations ?? [],
                                  );

                                  if (result != null) {
                                    final specList = List<String>.from(
                                      _userState?.specializations ?? [],
                                    );

                                    debugPrint("Result $result");

                                    setState(() {
                                      specList.addAll(result);
                                      final setData = specList.toSet().toList();

                                      context.read<UserBloc>().add(
                                        UpdateSpecialityInfo(
                                          speciality: setData,
                                        ),
                                      );
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 20),

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
              );
            },
          ),
        ),
      ),
    );
  }

  // * ────────────── LOADING FIRST PAGE ───────────────────────
  void getUserProfile() {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      setState(() {
        _userState = userState.user;
      });
    }
  }
}

class _basicInformation extends StatefulWidget {
  const _basicInformation();

  @override
  State<_basicInformation> createState() => _basicInformationState();
}

class _basicInformationState extends State<_basicInformation> {
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

          CustomStaticInput(label: 'Фамилия', value: name ?? ""),
          const SizedBox(height: 8),
          if (dob != null) ...[
            CustomStaticInput(label: "Дата рождения", value: dob ?? ""),
            const SizedBox(height: 8),
          ],
          CustomStaticInput(
            label: 'Почта',
            value: email ?? "",
            hasGreyBg: true,
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed(
                RouteName.editProfileBasicInfoApplicant,
              );

              debugPrint("🔐🔐 result: $result");

              if (result == true) {
                setState(() {
                  // refresh UI or anything you want
                });
              }
            },

            icon: const Icon(CupertinoIcons.pen, color: Colors.white, size: 18),
            label: const Text(
              "Редактировать",
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
  @override
  void initState() {
    super.initState();
    _loadAcceptOrdersFromPrefs();
  }

  Future<void> _loadAcceptOrdersFromPrefs() async {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool('accept_orders');
      // Only update if there's a saved value, otherwise use default (true)
      if (savedValue != null) {
        context.read<UserBloc>().add(
          UpdateAcceptOrdersEvent(acceptOrders: savedValue),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        bool acceptOrders = true; // Default to true
        if (state is UserLoaded) {
          acceptOrders = state.user.acceptOrders;
        }

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
                  CustomSwitch(
                    value: acceptOrders,
                    onChanged: (bool value) {
                      context.read<UserBloc>().add(
                        UpdateAcceptOrdersEvent(acceptOrders: value),
                      );
                      // Also save to SharedPreferences for persistence
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool('accept_orders', value);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildAccountButtons(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountButtons(BuildContext context) {
    return Column(
      children: [
        _updateButtons(
          text: "Управление подпиской",
          onTap: () {
            context.pushNamed(RouteName.viewPaymentScreenDetail);
          },
        ),
        const SizedBox(height: 16),

        _updateButtons(
          text: "Выйти из аккаунта",
          error: true,
          errorIcon: MediaRes.logoutIcon,
          onTap: () {
            showLogoutDialog(context, isApplicant: true, () async {
              print("Account logout");

              final lifeCycleState = context
                  .read<LifeCycleManagerBloc>()
                  .state;

              if (lifeCycleState is LifeCycleManagerStartedState) {
                context.read<LifeCycleManagerBloc>().add(
                  EndUserSessionEvent(
                    sessionId: lifeCycleState.sessionId,
                    endDate: DateTime.now().toUtc().toIso8601String(),
                  ),
                );
                await Future.delayed(const Duration(seconds: 1));
                context.read<ApplicantContactBloc>().add(
                  const LogoutAccountEvent(),
                );
                AuthService().signOut();
                context.pushNamed(RouteName.welcomePage);
              }
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
          },
          builder: (context, state) {
            return _updateButtons(
              text: "Удалить аккаунт",
              error: true,
              onTap: () {
                showDeleteAccountDialog(context, () {
                  print("Account deleted");

                  context.read<ApplicantContactBloc>().add(
                    const DeleteUserAccountEvent(),
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 24),
      ],
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
