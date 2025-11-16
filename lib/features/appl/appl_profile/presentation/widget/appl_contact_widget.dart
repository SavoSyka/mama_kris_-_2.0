import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_create_contact_screen.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/emp/emp_profile/presentation/emp_create_contact.dart';

class ApplContactWidget extends StatelessWidget {
  const ApplContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    List<ApplContactEntity> contacts = [];
    if (userState is UserLoaded) {
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
         await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApplCreateContactScreen()),
            );
         
          },
          icon: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
          label: const Text(
            "Добавить контакт",
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
      ],
    );
  }

  Widget _buildContactCard(BuildContext context, ApplContactEntity contact) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final updatedContact = await Navigator.push<ApplContactEntity>(
          context,
          MaterialPageRoute(
            builder: (_) => ApplCreateContactScreen(contact: contact),
          ),
        );

        if (updatedContact != null) {
          // TODO: trigger Bloc update for updated contact
        }
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

