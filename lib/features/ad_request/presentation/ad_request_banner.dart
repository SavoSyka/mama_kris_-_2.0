import 'package:flutter/material.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_screen.dart';
import 'package:mama_kris/features/ad_request/presentation/ad_request_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Зелёный баннер «20 000+ мам ищут удаленную работу прямо сейчас».
/// Тап — форма заявки на рекламу, крестик — скрыть баннер на [hideFor].
class AdRequestBanner extends StatefulWidget {
  const AdRequestBanner({super.key, this.bottomSpacing = 12});

  /// Отступ под баннером (пропадает вместе с баннером)
  final double bottomSpacing;

  /// Высота баннера с отступом — главный экран вычитает её из высоты карточки
  static const double height = 131;

  static const hideFor = Duration(days: 7);
  static const _prefsKey = 'ad_request_banner_hidden_at';

  /// Показан ли баннер (false, пока не прочитали настройки)
  static final ValueNotifier<bool> visible = ValueNotifier(false);

  static Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final hiddenAt = prefs.getInt(_prefsKey);
    visible.value =
        hiddenAt == null ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(hiddenAt),
            ) >=
            hideFor;
  }

  static Future<void> close() async {
    visible.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  State<AdRequestBanner> createState() => _AdRequestBannerState();
}

class _AdRequestBannerState extends State<AdRequestBanner> {
  void _open() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AdRequestScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AdRequestBanner.visible,
      builder: (context, visible, _) =>
          visible ? _buildBanner() : const SizedBox.shrink(),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomSpacing),
      child: Stack(
        children: [
          GestureDetector(
            onTap: _open,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AdUi.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 270),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '20 000+ мам ищут удаленную работу прямо сейчас',
                            style: AdUi.manrope(
                              16,
                              FontWeight.w600,
                              color: Colors.white,
                              lineHeight: 20.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ваша идеальная ЦА для покупки детских товаров, одежды, косметики.',
                            style: AdUi.manrope(
                              12,
                              FontWeight.w500,
                              color: Colors.white,
                              lineHeight: 15.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Займите рекламное место!',
                          style: AdUi.manrope(
                            10,
                            FontWeight.w500,
                            color: AdUi.grey,
                            lineHeight: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.south_east,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Semantics(
              button: true,
              label: 'Закрыть баннер',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: AdRequestBanner.close,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
