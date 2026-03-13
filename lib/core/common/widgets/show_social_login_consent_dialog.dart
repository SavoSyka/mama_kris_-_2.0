import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';

class SocialLoginConsentResult {
  final bool accepted;
  final bool subscribeEmail;

  const SocialLoginConsentResult({
    required this.accepted,
    required this.subscribeEmail,
  });
}

/// Shows a consent dialog for social login (Apple/Google).
/// Returns [SocialLoginConsentResult] with acceptance and email subscription choice.
/// Returns null if dismissed without accepting.
Future<SocialLoginConsentResult?> showSocialLoginConsentDialog(
  BuildContext context, {
  bool isEmployee = false,
}) async {
  return showModalBottomSheet<SocialLoginConsentResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    builder: (ctx) => _SocialLoginConsentSheet(isEmployee: isEmployee),
  );
}

class _SocialLoginConsentSheet extends StatefulWidget {
  final bool isEmployee;

  const _SocialLoginConsentSheet({required this.isEmployee});

  @override
  State<_SocialLoginConsentSheet> createState() =>
      _SocialLoginConsentSheetState();
}

class _SocialLoginConsentSheetState extends State<_SocialLoginConsentSheet> {
  bool _acceptPrivacyPolicy = false;
  bool _acceptTermsOfUse = false;
  bool _subscribeEmail = false;

  bool get _canProceed => _acceptPrivacyPolicy && _acceptTermsOfUse;

  Color get _primaryColor =>
      widget.isEmployee ? AppPalette.empPrimaryColor : AppPalette.primaryColor;

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
                onTap: () => Navigator.of(context).pop(null),
                child: const CustomImageView(
                  imagePath: MediaRes.modalCloseIcon,
                  width: 32,
                ),
              ),
            ),
          ),

          // White container
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Согласие',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Jost',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Для продолжения необходимо принять условия',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Privacy policy checkbox
                          _buildCheckboxRow(
                            value: _acceptPrivacyPolicy,
                            onTap: () => setState(
                              () =>
                                  _acceptPrivacyPolicy = !_acceptPrivacyPolicy,
                            ),
                            text:
                                'Я принимаю условия Политики конфиденциальности и даю согласие на обработку моих персональных данных в соответствии с законодательством',
                            isLink: true,
                            linkUrl: AppConstants.privacyAgreement,
                          ),
                          const SizedBox(height: 12),

                          // Terms of use checkbox
                          _buildCheckboxRow(
                            value: _acceptTermsOfUse,
                            onTap: () => setState(
                              () => _acceptTermsOfUse = !_acceptTermsOfUse,
                            ),
                            text: 'Я соглашаюсь с Условиями использования',
                            isLink: true,
                            linkUrl: AppConstants.termsAgreement,
                          ),
                          const SizedBox(height: 12),

                          // Email subscription checkbox
                          _buildCheckboxRow(
                            value: _subscribeEmail,
                            onTap: () => setState(
                              () => _subscribeEmail = !_subscribeEmail,
                            ),
                            text:
                                'Согласен на получение рассылки по электронной почте',
                            isLink: false,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Continue button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 53,
                      child: DecoratedBox(
                        decoration: _canProceed
                            ? (widget.isEmployee
                                    ? BoxDecoration(
                                        color: AppPalette.empPrimaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x330074BC),
                                            offset: Offset(0, 1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      )
                                    : AppTheme.primaryColordecoration)
                                .copyWith(
                                borderRadius: BorderRadius.circular(20),
                              )
                            : BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                        child: InkWell(
                          onTap: _canProceed
                              ? () => Navigator.of(context).pop(
                                    SocialLoginConsentResult(
                                      accepted: true,
                                      subscribeEmail: _subscribeEmail,
                                    ),
                                  )
                              : null,
                          borderRadius: BorderRadius.circular(20),
                          child: const Center(
                            child: Text(
                              'Продолжить',
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow({
    required bool value,
    required VoidCallback onTap,
    required String text,
    required bool isLink,
    String? linkUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Image.asset(
            value ? MediaRes.markedBox : MediaRes.unMarkedBox,
            width: 28,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: isLink && linkUrl != null
                ? () => HandleLaunchUrl.launchUrls(context, url: linkUrl)
                : onTap,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Manrope',
                color: isLink ? _primaryColor : AppPalette.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
