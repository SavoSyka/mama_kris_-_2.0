import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

enum FilterType { active, drafts, archive }

class EmpHomeScreen extends StatefulWidget {
  const EmpHomeScreen({super.key});

  @override
  _EmpHomeScreenState createState() => _EmpHomeScreenState();
}

class _EmpHomeScreenState extends State<EmpHomeScreen> {
  FilterType selectedFilter = FilterType.active;

  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Software Engineer',
      'description': 'Develop and maintain software applications.',
      'salary': '100000',
      'status': FilterType.active,
    },
    {
      'title': 'Product Manager',
      'description': 'Oversee product development and strategy.',
      'salary': '120000',
      'status': FilterType.archive,
    },
    {
      'title': 'Designer',
      'description': 'Create user interfaces and experiences.',
      'salary': '90000',
      'status': FilterType.archive,
    },
  ];

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
                        Container(
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Updated section with enum values for Активные, Черновики, Архив
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = FilterType.active;
                                      });
                                    },
                                    child: _FilterCard(
                                      isSelected:
                                          selectedFilter == FilterType.active,
                                      text: 'Активные',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = FilterType.drafts;
                                      });
                                    },
                                    child: _FilterCard(
                                      isSelected:
                                          selectedFilter == FilterType.drafts,
                                      text: 'Черновики',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = FilterType.archive;
                                      });
                                    },
                                    child: _FilterCard(
                                      isSelected:
                                          selectedFilter == FilterType.archive,
                                      text: 'Архив',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        const _CreateJobCard(),

                        // ListView.separated(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemBuilder: (context, index) {
                        //     if (!(jobs[index]['status'] ==  selectedFilter))
                        //       return Container();
                        //     return JobListItem(
                        //       jobTitle: jobs[index]['title'] ?? 'No Title',
                        //       salaryRange: jobs[index]['salary'] ?? 'No Salary',
                        //       onTap: () async {
                        //         await ApplicantJobDetail(context);
                        //       },
                        //     );
                        //   },
                        //   separatorBuilder: (context, index) =>
                        //       const SizedBox(height: 8),
                        //   itemCount: jobs.length,
                        // ),
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

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isSelected ? Border.all(color: AppPalette.empPrimaryColor) : null,
      ),
      child: CustomText(text: text),
    );
  }
}

class _AdCards extends StatelessWidget {
  const _AdCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: AppTheme.cardDecoration,
      child:  Column(
        children: [
          const CustomText(
            text: 'Хотите создать еще вакансию?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration,
            child: const CustomText(
              text: 'Создать',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateJobCard extends StatelessWidget {
  const _CreateJobCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text(
            'Вакансий еще нет',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 175,
            child: Text(
              'Но вы можете рассказать о своей задаче нашим мамам',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
          ),
          const SizedBox(height: 24),

          CustomButtonSec(
            btnText: '',
            onTap: () {
              context.pushNamed(RouteName.createJobPageOne);
            },
            child: const Text(
              'Рассказать',
              style: TextStyle(
                color: Color(0xFF0073BB),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
          ),
       
        ],
      ),
    );
  }
}
