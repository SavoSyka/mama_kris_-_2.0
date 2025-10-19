import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_filter_bottomsheet.dart';
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
                                onTap: () async {},
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
                                itemBuilder: (context, index) =>
                                    const VerticalJobList(),
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
      decoration: AppTheme.cardDecoration,
      child: CustomText(text: text),
    );
  }
}

class VerticalJobList extends StatefulWidget {
  const VerticalJobList({super.key});

  @override
  _VerticalJobListState createState() => _VerticalJobListState();
}

class _VerticalJobListState extends State<VerticalJobList> {
  final GlobalKey _menuKey = GlobalKey();

  void _showJobOptionsMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            // Handle add to favorites
          },
          child: const Text('Добавить в избранное'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle share
            Share.share(
              'Check out this job: Дизайнер инфорграфики - 6000 - 12 000 руб',
              subject: 'Job Opportunity',
            );
          },
          child: const Text('Поделиться'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report
          },
          child: const Text(
            'Отправить жалобу',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await ApplicantFilterBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: AppTheme.cardDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                CustomText(
                  text: 'Дизайнер инфорграфики',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '6000 - 12 000 руб',
                  style: TextStyle(
                    color: Color(0xFF596574),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
              ],
            ),

            InkWell(
              onTap: () {
                _showJobOptionsMenu(context);
              },
              child: CustomImageView(
                key: _menuKey,
                imagePath: MediaRes.verticalDots,
                width: 20,
              ),
            ),
          ],
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
