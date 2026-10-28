import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

/// Персональные цифры на экране тарифов: вакансии в сферах из профиля,
/// новые за сутки, размытые свежие вакансии и сколько мам уже с нами.
/// Если запрос не удался — блок просто не показывается.
class PaywallPersonalBlock extends StatefulWidget {
  const PaywallPersonalBlock({super.key});

  @override
  State<PaywallPersonalBlock> createState() => _PaywallPersonalBlockState();
}

class _PaywallInfo {
  _PaywallInfo({
    required this.sphereTitles,
    required this.jobs,
    required this.newToday,
    required this.preview,
    required this.moms,
  });

  final List<String> sphereTitles;
  final int jobs;
  final int newToday;
  final List<({String title, num salary})> preview;
  final int? moms;
}

class _PaywallPersonalBlockState extends State<PaywallPersonalBlock> {
  _PaywallInfo? _info;

  static const _grey = Color(0xFF596574);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final dio = sl<Dio>();
      final userId = await sl<AuthLocalDataSource>().getUserId();
      final results = await Future.wait([
        dio.get(ApiConstants.paywallInfo(userId)),
        dio
            .get(ApiConstants.getPublicCounts)
            .then<Response?>((r) => r)
            .catchError((_) => null),
      ]);
      final data = results[0]!.data as Map<String, dynamic>;
      final counts = results[1]?.data as Map<String, dynamic>?;
      if (!mounted) return;
      setState(() {
        _info = _PaywallInfo(
          sphereTitles: List<String>.from(data['sphereTitles'] ?? const []),
          jobs: (data['jobs'] as num?)?.toInt() ?? 0,
          newToday: (data['newToday'] as num?)?.toInt() ?? 0,
          preview: [
            for (final p in (data['preview'] as List? ?? const []))
              (
                title: (p['title'] ?? '').toString(),
                salary: (p['salary'] as num?) ?? 0,
              ),
          ],
          moms: (counts?['users'] as num?)?.toInt(),
        );
      });
    } catch (e) {
      debugPrint('Paywall info not loaded: $e');
    }
  }

  static String _num(int value) =>
      value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+$)'), (_) => ' ');

  static String _vacancies(int n) {
    final mod10 = n % 10, mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return 'вакансия';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'вакансии';
    }
    return 'вакансий';
  }

  String get _headline {
    final info = _info!;
    final where = switch (info.sphereTitles.length) {
      0 => 'Сейчас в базе',
      1 => 'В вашей сфере «${info.sphereTitles.first}» сейчас',
      _ => 'В ваших сферах сейчас',
    };
    return '$where ${_num(info.jobs)} ${_vacancies(info.jobs)}';
  }

  @override
  Widget build(BuildContext context) {
    final info = _info;
    if (info == null || info.jobs == 0) return const SizedBox.shrink();

    const textStyle = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.3,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2FBF3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppPalette.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_headline, style: textStyle),
                if (info.newToday > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '+${_num(info.newToday)} новых за сегодня',
                    style: textStyle.copyWith(
                      fontSize: 14,
                      color: AppPalette.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (info.preview.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _BlurredPreview(preview: info.preview),
                ],
              ],
            ),
          ),
          if (info.moms != null && info.moms! > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  size: 18,
                  color: AppPalette.primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_num(info.moms! ~/ 100 * 100)}+ мам уже ищут работу с MamaKris',
                    style: textStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BlurredPreview extends StatelessWidget {
  const _BlurredPreview({required this.preview});

  final List<({String title, num salary})> preview;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            children: [
              for (final p in preview)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.salary > 0
                            ? 'от ${p.salary.round()} руб'
                            : 'По договоренности',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: Color(0xFF596574),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332E7866),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: AppPalette.primaryColor,
              ),
              SizedBox(width: 6),
              Text(
                'Откроются после оплаты',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
