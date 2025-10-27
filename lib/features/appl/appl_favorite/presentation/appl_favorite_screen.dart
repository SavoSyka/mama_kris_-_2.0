import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/job_list_item.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_slider.dart';
import 'package:share_plus/share_plus.dart';

class ApplFavoriteScreen extends StatefulWidget {
  const ApplFavoriteScreen({super.key});

  @override
  _ApplFavoriteScreenState createState() => _ApplFavoriteScreenState();
}

class _ApplFavoriteScreenState extends State<ApplFavoriteScreen> {
  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1;

  bool isSlider = false;

  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Software Engineer',
      'description': 'Develop and maintain software applications.',
      'salary': '100000',
    },
    {
      'title': 'Product Manager',
      'description': 'Oversee product development and strategy.',
      'salary': '120000',
    },
    {
      'title': 'Designer',
      'description': 'Create user interfaces and experiences.',
      'salary': '90000',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Мои заказы',
      showLeading: false,
      alignTitleToEnd: false,
      ),

      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: CustomDefaultPadding(
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => JobListItem(
                            jobTitle: jobs[index]['title'] ?? 'No Title',
                            salaryRange: jobs[index]['salary'] ?? 'No Salary',
                            onTap: () async {
                              await ApplicantJobDetail(context, showStar: false);
                            },
                            showAddToFavorite: false,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: jobs.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdCards extends StatelessWidget {
  const _AdCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: AppTheme.cardDecoration,
      child: const Column(
        children: [
          CustomText(
            text: 'Место для рекламы',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF12902A),
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          CustomText(
            text: 'Нажмите, чтобы оставить заявку',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF596574),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
