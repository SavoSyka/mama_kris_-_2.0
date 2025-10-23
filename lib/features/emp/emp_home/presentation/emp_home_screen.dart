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
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_filter.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_slider.dart';
import 'package:share_plus/share_plus.dart';

class ApplHomeScreen extends StatefulWidget {
  const ApplHomeScreen({super.key});

  @override
  _ApplHomeScreenState createState() => _ApplHomeScreenState();
}

class _ApplHomeScreenState extends State<ApplHomeScreen> {
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

  void _handleVacancyReaction({required bool isLiked}) {
    setState(() {
      previousVacancyIndex = currentVacancyIndex;
      slideDirection = isLiked ? -1 : 1;
      currentVacancyIndex = (currentVacancyIndex + 1) % jobs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Вакансии',
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
                        const _Searchbox(),
                        const SizedBox(height: 14),
                        Container(
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSlider = true;
                                      });
                                    },
                                    child: _FilterCard(
                                      isSelected: isSlider,
                                      text: 'Слайдер',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSlider = false;
                                      });
                                    },
                                    child: _FilterCard(
                                      isSelected: !isSlider,
                                      text: 'Слайдер',
                                    ),
                                  ),
                                ],
                              ),

                              InkWell(
                                onTap: () async {
                                  ApplicantJobFilter(context);
                                },
                                child: const CustomImageView(
                                  imagePath: MediaRes.btnFilter,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        !isSlider
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => JobListItem(
                                  jobTitle: jobs[index]['title'] ?? 'No Title',
                                  salaryRange:
                                      jobs[index]['salary'] ?? 'No Salary',
                                  onTap: () async {
                                    await ApplicantJobDetail(context);
                                  },
                                ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemCount: jobs.length,
                              )
                            : ApplicantJobSlider(
                                vacancy: jobs[currentVacancyIndex],
                                vacancyIndex: currentVacancyIndex,
                                previousVacancyIndex: previousVacancyIndex,
                                slideDirection: slideDirection,
                                onInterestedPressed: () {
                                  _handleVacancyReaction(isLiked: true);
                                },
                                onNotInterestedPressed: () {
                                  _handleVacancyReaction(isLiked: false);
                                },
                              ),
                        const SizedBox(height: 16),
                        const _AdCards(),
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

class _Searchbox extends StatelessWidget {
  const _Searchbox({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      hintText: 'Текст',
      labelText: "Имя",

      controller: TextEditingController(),
      suffixIcon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomImageView(
          imagePath: MediaRes.search,
          width: 12,
          height: 12,
        ),
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({super.key, required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isSelected ? Border.all(color: AppPalette.primaryColor) : null,
      ),
      child: CustomText(text: text),
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
