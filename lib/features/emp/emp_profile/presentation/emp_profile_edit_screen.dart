import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/auth/auth_service.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/emp_create_contact_screen.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/widget/emp_view_basic_information.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/widget/show_delete_icon_dialog.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/widget/show_logout_dialog.dart';
import 'package:mama_kris/features/emp/employe_contact/presentation/bloc/employee_contact_bloc.dart';

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
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          EmpViewBasicInformation(),
                          const SizedBox(height: 20),

                          // Контакты -- Contacts
                          const ContactsWidget(),
                          const SizedBox(height: 20),

                          /// Специализация -- Speciliasaton
                          const _accounts(),
                          const SizedBox(height: 20),

                          const CustomButtonEmployee(
                            btnText: 'Сохранить изменения',
                          ),
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

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<EmpUserBloc>().state;

    List<ContactEntity> contacts = [];
    if (userState is EmpUserLoaded) {
      contacts = userState.user.contacts ?? [];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Контакты",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Manrope',
              color: CupertinoColors.label,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          if (contacts.isEmpty)
            _buildEmptyState(context)
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _buildContactCard(context, contact);
              },
            ),

            const SizedBox(height: 12),
            _buildEmptyState(context, showText: false),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {bool showText = true}) {
    return Column(
      children: [
        if (showText) ...[
          const SizedBox(height: 8),
          const Text(
            "У вас пока нет контактов.\nСоздайте новый контакт, чтобы добавить способы связи.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
        ],
        ElevatedButton.icon(
          onPressed: () async {
            final newContact = context.pushNamed(
              RouteName.editProfileContactInfoEmployee,
            );
            // TODO: trigger Bloc update for new contact
          },
          icon: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
          label: const Text(
            "Добавить контакт",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.empPrimaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(BuildContext context, ContactEntity contact) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final updatedContact = context.pushNamed(
          RouteName.editProfileContactInfoEmployee,
          extra: {'contact': contact},
        );

        // TODO: trigger Bloc update for updated contact
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CupertinoColors.separator.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header row with icon and name ---
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppPalette.empPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: AppPalette.empPrimaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    contact.name ?? "Без имени",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.right_chevron,
                  size: 18,
                  color: CupertinoColors.systemGrey2,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- Contact methods ---
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.telegram != null)
                    _buildSmartRow(
                      icon: Icons.send_rounded,
                      value: contact.telegram!,
                      platformColor: const Color(0xFF229ED9),
                    ),
                  if (contact.whatsapp != null)
                    _buildSmartRow(
                      icon: Icons.phone_rounded,
                      value: contact.whatsapp!,
                      platformColor: const Color(0xFF25D366),
                    ),
                  if (contact.vk != null)
                    _buildSmartRow(
                      icon: Icons.language_rounded,
                      value: contact.vk!,
                      platformColor: const Color(0xFF4680C2),
                    ),
                  if (contact.email != null)
                    _buildSmartRow(
                      icon: CupertinoIcons.envelope_fill,
                      value: contact.email!,
                      platformColor: CupertinoColors.systemBlue,
                    ),
                  if (contact.phone != null)
                    _buildSmartRow(
                      icon: CupertinoIcons.phone_fill,
                      value: contact.phone!,
                      platformColor: CupertinoColors.systemGrey,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Reusable small info row (same as in modal) ----
Widget _buildSmartRow({
  required IconData icon,
  required String value,
  required Color platformColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: platformColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: platformColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.label.withOpacity(0.95),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    ),
  );
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

          _updateButtons(
            text:
                "MУправление подпиской", //"Управление подпиской", // manage subscription
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
              showLogoutDialog(context, () {
                print("Account deleted");

                context.read<EmployeeContactBloc>().add(
                  const EmpLogoutAccountEvent(),
                );
                AuthService().signOut();

                context.pushNamed(RouteName.welcomePage);
              });
            },
          ),
          const SizedBox(height: 16),
          BlocConsumer<EmployeeContactBloc, EmployeeContactState>(
            listener: (context, state) {
              if (state is AccountDeleteLoadingState) {
                showIOSLoader(context);
              } else if (state is UserAccountDeleted) {
                Navigator.pop(context);
                context.read<EmployeeContactBloc>().add(
                  const EmpLogoutAccountEvent(),
                );
                AuthService().signOut();
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

                    context.read<EmployeeContactBloc>().add(
                      const DeleteUserAccountEvent(),
                    );
                    // context.pushNamed(RouteName.welcomePage);
                  });
                  // context.pushNamed(RouteName.welcomePage);
                },
              );
            },
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
