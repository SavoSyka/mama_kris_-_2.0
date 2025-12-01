import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class EmptyJobView extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final String? title;
  const EmptyJobView({super.key, this.onRefresh, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          color: AppPalette.primaryColor,
          backgroundColor: Colors.white,
          child: Container(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 32,
                                ),
                                decoration: AppTheme.cardDecoration,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.work_outline,
                                      size: 100,
                                      color: AppPalette.primaryColor,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      title ?? "Вакансии не найдены",

                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Потяните вниз, чтобы обновить, или попробуйте позже.",

                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    const SizedBox(height: 32),
                                    ElevatedButton.icon(
                                      onPressed: onRefresh,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppPalette.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Обновить',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
