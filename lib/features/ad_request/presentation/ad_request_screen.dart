import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama_kris/core/common/widgets/show_toast.dart';
import 'package:mama_kris/core/constants/api_constants.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_success_screen.dart';

/// Значения совпадают с AD_REQUEST_PERIODS на бэкенде (src/advertisement/ad-request.dto.ts)
const adRequestPeriods = <String, String>{
  'day': '1 день',
  'week': '1 неделя',
  'month': '1 месяц (скидка 10%)',
  'quarter': '3 месяца (скидка 35%)',
  'year': '1 год ( скидка 50%)',
};

class AdRequestScreen extends StatefulWidget {
  const AdRequestScreen({super.key});

  @override
  State<AdRequestScreen> createState() => _AdRequestScreenState();
}

class _AdRequestScreenState extends State<AdRequestScreen> {
  final _brand = TextEditingController();
  final _website = TextEditingController();
  final _bannerLink = TextEditingController();
  final _contact = TextEditingController();
  String _period = 'day';
  bool _submitted = false;
  bool _sending = false;

  @override
  void dispose() {
    _brand.dispose();
    _website.dispose();
    _bannerLink.dispose();
    _contact.dispose();
    super.dispose();
  }

  String? _required(TextEditingController c) =>
      _submitted && c.text.trim().isEmpty ? 'Заполните поле' : null;

  Future<void> _send() async {
    setState(() => _submitted = true);
    if ([_brand, _website, _contact].any((c) => c.text.trim().isEmpty)) return;

    setState(() => _sending = true);
    try {
      await sl<Dio>().post(
        ApiConstants.adRequest,
        data: {
          'brand': _brand.text.trim(),
          'website': _website.text.trim(),
          'period': _period,
          if (_bannerLink.text.trim().isNotEmpty)
            'bannerLink': _bannerLink.text.trim(),
          'contact': _contact.text.trim(),
        },
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(AdRequestSuccessScreen.route());
    } on DioException catch (e) {
      if (!mounted) return;
      final tooMany = e.response?.statusCode == 429;
      showToast(
        context,
        message: tooMany
            ? 'Слишком много заявок, попробуйте позже'
            : 'Не удалось отправить заявку. Попробуйте ещё раз',
        errorTitle: 'Ошибка',
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AdUi.formBg,
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AdSmallButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Забронировать рекламное место',
                  style: AdUi.manrope(20, FontWeight.w600, lineHeight: 26),
                ),
                const SizedBox(height: 16),
                Text(
                  'Покажите свой бренд 20 000+ мамам.',
                  style: AdUi.manrope(
                    16,
                    FontWeight.w500,
                    color: AdUi.grey,
                    lineHeight: 20.8,
                  ),
                ),
                const SizedBox(height: 16),
                _card(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _field(
                        'Название вашего бренда/компании',
                        _brand,
                        error: _required(_brand),
                      ),
                      const SizedBox(height: 12),
                      _field(
                        'Ссылка на ваш сайт',
                        _website,
                        keyboard: TextInputType.url,
                        error: _required(_website),
                      ),
                      const SizedBox(height: 12),
                      _label('На какой срок хотите забронировать?'),
                      const SizedBox(height: 8),
                      _card(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            for (final e in adRequestPeriods.entries) ...[
                              if (e.key != adRequestPeriods.keys.first)
                                const SizedBox(height: 24),
                              _radio(e.key, e.value),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _field(
                        'Какую ссылку зашить за баннер? Необязательно',
                        _bannerLink,
                        keyboard: TextInputType.url,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        'Ваш телефон или Telegram для связи',
                        _contact,
                        error: _required(_contact),
                        action: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _card(
                  padding: const EdgeInsets.all(24),
                  stroke: AdUi.greyStroke,
                  shadow: true,
                  child: GestureDetector(
                    onTap: _sending ? null : _send,
                    child: Container(
                      height: 53,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AdUi.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x330074BC),
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: _sending
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Отправить заявку',
                              style: AdUi.manrope(
                                16,
                                FontWeight.w600,
                                color: Colors.white,
                                lineHeight: 20.8,
                              ),
                            ),
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

  Widget _card({
    required Widget child,
    required EdgeInsets padding,
    Color stroke = AdUi.cardStroke,
    bool shadow = false,
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: stroke),
        boxShadow: shadow
            ? const [
                BoxShadow(
                  color: Color(0x330074BC),
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  Widget _label(String text) =>
      Text(text, style: AdUi.manrope(16, FontWeight.w500, lineHeight: 20.8));

  Widget _field(
    String label,
    TextEditingController controller, {
    String? error,
    TextInputType keyboard = TextInputType.text,
    TextInputAction action = TextInputAction.next,
  }) {
    final textStyle = AdUi.manrope(
      16,
      FontWeight.w600,
      color: AdUi.grey,
      lineHeight: 20.8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: error != null ? const Color(0xFFE53935) : AdUi.greyStroke,
            ),
            boxShadow: const [AdUi.shadowSoft],
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            textInputAction: action,
            onChanged: (_) {
              if (_submitted) setState(() {});
            },
            style: textStyle.copyWith(color: Colors.black),
            cursorColor: AdUi.darkGreen,
            decoration: InputDecoration(
              isCollapsed: true,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Текст',
              hintStyle: textStyle,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              error,
              style: AdUi.manrope(
                12,
                FontWeight.w500,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
      ],
    );
  }

  Widget _radio(String value, String label) {
    final selected = _period == value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _period = value),
      child: SizedBox(
        height: 29,
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AdUi.darkGreen : Colors.white,
                border: selected
                    ? null
                    : Border.all(color: const Color(0x1F596574)),
                boxShadow: const [AdUi.shadowSoft],
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  style: AdUi.manrope(
                    16,
                    FontWeight.w600,
                    color: AdUi.grey,
                    lineHeight: 20.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
