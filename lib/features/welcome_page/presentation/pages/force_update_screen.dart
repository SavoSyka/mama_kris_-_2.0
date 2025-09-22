import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, required this.isAndroid});
  final bool isAndroid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomDefaultPadding(
        child: Column(
          children: [
            const Spacer(),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 42.h),
              child: Column(
                children: [
                  Image.asset(
                    MediaRes.forceUpdate,
                    height: 84,
                    width: 84,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: AppTextContents.updateRequired,

                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: AppTextContents.updateDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF595959),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            CustomPrimaryButton(
              btnText: AppTextContents.updateNow,
              onTap: () async {
                await HandleLaunchUrl.launchUrls(
                  context,

                  url: isAndroid
                      ? AppConstants.playStoreUrl
                      : AppConstants.appStoreUrl,
                );
              },
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
