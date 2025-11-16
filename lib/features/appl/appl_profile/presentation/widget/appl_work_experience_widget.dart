import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/appl_profile_edit_work_experience.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';

import '../../../../../core/constants/app_palette.dart';
import '../../../../../core/theme/app_theme.dart';

class ApplWorkExperienceWidget extends StatelessWidget {
  const ApplWorkExperienceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    List<ApplWorkExperienceEntity> exp = [];
    if (userState is UserLoaded) {
      exp = userState.user.workExperience ?? [];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Опыт работы",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Manrope',
              color: CupertinoColors.label,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          if (exp.isEmpty)
            _buildEmptyState(context)
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: exp.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final work = exp[index];
                return _buildExperienceCard(context, work);
              },
            ),

            const SizedBox(height: 16),
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
            "У вас пока нет опыта работы.\nДобавьте место работы, чтобы заполнить профиль.",
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
            context.pushNamed(RouteName.editProfileworkExpereinceInfoApplicant);
          },
          icon: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
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
      ],
    );
  }

  //---------------------------------------------------------------------------
  // NEW EXPERIENCE CARD (Your layout)
  //---------------------------------------------------------------------------

  Widget _buildExperienceCard(
    BuildContext context,
    ApplWorkExperienceEntity exp,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();

        context.pushNamed(
          RouteName.editProfileworkExpereinceInfoApplicant,
          extra: {"experience": exp},
        );
      },
      child: _experienceItems(
        title: exp.company ?? "Компания не указана",
        position: exp.position ?? "Должность не указана",
        datePeriod: exp.isPresent == true
            ? "${exp.startDate ?? ''} — наст. время"
            : "${exp.startDate ?? ''} — ${exp.endDate ?? ''}",
      ),
    );
  }
}

Widget _experienceItems({
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
    child: Row(
      children: [
        Expanded(
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
        ),

        const Icon(CupertinoIcons.pencil),
      ],
    ),
  );
}
