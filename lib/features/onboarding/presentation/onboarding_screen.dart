import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/onboarding/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.isApplicant});

  final bool isApplicant;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _showDialog = true;
  int _currentStep = 0;

  List<OnboardingStep> get _steps =>
      widget.isApplicant ? applicantOnboardingSteps : employeeOnboardingSteps;

  Color get _primaryColor =>
      widget.isApplicant ? AppPalette.primaryColor : AppPalette.empPrimaryColor;

  void _startOnboarding() {
    setState(() {
      _showDialog = false;
    });
  }

  void _skipOnboarding() {
    _completeAndNavigate();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeAndNavigate();
    }
  }

  Future<void> _completeAndNavigate() async {
    await sl<AuthLocalDataSource>().saveOnboardingCompleted(true);
    if (!mounted) return;

    if (widget.isApplicant) {
      context.goNamed(RouteName.homeApplicant);
    } else {
      context.goNamed(RouteName.homeEmploye);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showDialog) {
      return _buildDialogScreen();
    }
    return _buildStepScreen();
  }

  Widget _buildDialogScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: IconButton(
                  onPressed: _skipOnboarding,
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: AppTheme.cardDecoration.copyWith(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: _primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A2E7866),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Онбординг',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Хотите пройти онбординг? Покажем как пользоваться приложением',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Вы можете пройти его в любое время в найстройках',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Start onboarding button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: _startOnboarding,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Пройти онбординг',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Skip button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: _skipOnboarding,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              'Позже',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
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
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepScreen() {
    final step = _steps[_currentStep];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (screenshot)
          Image.asset(
            step.backgroundImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: widget.isApplicant
                    ? const Color(0xFFF5F5F5)
                    : AppPalette.empBgColor,
                child: const Center(
                  child: Text('Background image placeholder'),
                ),
              );
            },
          ),

          // Hint card
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: (step.hintBottomPosition?.h ?? 80.h) + 40.h,
            top: step.hintTopPosition?.h,
            child: step.hintTopPosition != null
                ? Align(
                    alignment: Alignment.topCenter,
                    child: _buildHintCard(step),
                  )
                : _buildHintCard(step),
          ),
        ],
      ),
    );
  }

  Widget _buildHintCard(OnboardingStep step) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with step counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step.title,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${_currentStep + 1}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${_steps.length}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          // Description
          Text(
            step.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 32.h),
          // Next button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _nextStep,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _currentStep < _steps.length - 1 ? 'Дальше' : 'Начать',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
