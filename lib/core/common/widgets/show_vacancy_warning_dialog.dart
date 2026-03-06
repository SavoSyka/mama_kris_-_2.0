import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_support/presentation/appl_support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';

const _warningDismissedKey = '_vacancy_warning_dismissed';

/// Shows a vacancy warning dialog before proceeding with the "Interested" action.
/// Returns `true` if the user confirmed (tapped "Понятно"), `false` otherwise.
Future<bool> showVacancyWarningDialog(BuildContext context) async {
  final prefs = sl<SharedPreferences>();
  final isDismissed = prefs.getBool(_warningDismissedKey) ?? false;

  if (isDismissed) return true;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: true,
    builder: (ctx) => const _VacancyWarningSheet(),
  );

  return result ?? false;
}

class _VacancyWarningSheet extends StatelessWidget {
  const _VacancyWarningSheet();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Column(
        children: [
          const Spacer(),

          // Close button - outside the white container
          Padding(
            padding: const EdgeInsets.only(right: 20.0, bottom: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(false),
                child: const CustomImageView(
                  imagePath: MediaRes.modalCloseIcon,
                  width: 32,
                ),
              ),
            ),
          ),

          // White container with content and buttons
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scrollable content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Предупреждение!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Jost',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Платформа выступает посредником и не несёт ответственность за прямые отношения между вами и работодателем',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Проверьте информацию о работодателе самостоятельно. Если что-то вызывает сомнение — сообщите нам.\n'
                            'Удаленные вакансии добавляются автоматически с открытых источников с помощью ИИ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Несмотря на наши модерационные меры, мы не можем гарантировать отсутствие ошибок или недостоверности.\n'
                            'Просим относиться с осторожностью и сообщать о подозрительных предложениях в нашу тех. поддержку',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                              final articleData = supports.firstWhere(
                                (s) => s['routeName'] == RouteName.articleTwo,
                                orElse: () => <String, dynamic>{},
                              );
                              if (articleData.isNotEmpty) {
                                GoRouter.of(context).pushNamed(
                                  RouteName.articleTwo,
                                  extra: {'support': articleData},
                                );
                              }
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Обязательно прочтите статью ',
                                  ),
                                  TextSpan(
                                    text: '«Как защититься от мошенников?»',
                                    style: TextStyle(
                                      color: AppPalette.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' в разделе «Поддержка»',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        // Primary - "Понятно"
                        SizedBox(
                          width: double.infinity,
                          height: 53,
                          child: DecoratedBox(
                            decoration: AppTheme.primaryColordecoration.copyWith(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(true),
                              borderRadius: BorderRadius.circular(20),
                              child: const Center(
                                child: Text(
                                  'Понятно',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Jost',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Secondary - "Больше не показывать"
                        SizedBox(
                          width: double.infinity,
                          height: 53,
                          child: DecoratedBox(
                            decoration: AppTheme.cardDecoration.copyWith(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                final prefs = sl<SharedPreferences>();
                                await prefs.setBool(
                                  _warningDismissedKey,
                                  true,
                                );
                                navigator.pop(true);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Center(
                                child: Text(
                                  'Больше не показывать',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Jost',
                                    color: AppPalette.primaryColor 
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
