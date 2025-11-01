import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/entity/job_model.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/add_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/empty_posted_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/home_bottomsheet/profession_bottomsheet.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _tabList = [
    AppTextContents.active,
    AppTextContents.drafts,
    AppTextContents.archive,
  ];

  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  int _selectedIndex = 0;

  List<JobModel> _allJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/job.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _allJobs = jsonData.map((e) => JobModel.fromJson(e)).toList();
      _isLoading = false;
    });

    debugPrint("Jobs");
  }

  final Map<String, String> _tabStatusMap = {
    'Активные': 'active',
    'Черновики': 'draft',
    'Архив': 'archived',
  };

  List<JobModel> get filteredJobs {
    final selectedTab = _tabList[_selectedIndex];
    final status = _tabStatusMap[selectedTab] ?? '';
    return _allJobs.where((job) => job.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomText(
              text: AppTextContents.vacancies,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = _tabList[index];

                        return EmployeHomeCard(
                          text: _tabList[index],
                          isSelected: _selectedIndex == index,
                          onTap: () {
                            if (index != _selectedIndex) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: _tabList.length,
                    ),
                  ),

                  //  Row(
                  //   spacing: 10,
                  //   children: [
                  //     EmployeHomeCard(text: AppTextContents.active),
                  //     EmployeHomeCard(text: AppTextContents.drafts),
                  //     EmployeHomeCard(text: AppTextContents.archive),
                  //   ],
                  // ),
                ),

                AddJob(
                  onTap: () async {
                    debugPrint("che");
                    String? profession = await HomeBottomsheet.profession(
                      context,
                      _professionController,
                      () {
                        print("Next pressed for profession");
                      },
                    );
                    print("Selected profession: $profession");
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredJobs.isEmpty
              ? const EmptyPostedJob()
              : Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: filteredJobs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),

                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return _jobCard(
                        title: job.title,
                        price: '${job.price} руб',
                      );
                    },
                  ),
                ),

          // const EmptyPostedJob(),
          // SizedBox(height: 24.h),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: CustomActionButton(
              btnText: AppTextContents.createJob,
              isSecondaryPrimary: true,
              isSecondary: false,
              suffix: const CustomImageView(
                imagePath: MediaRes.plusCircle,
                width: 16,
              ),
            
              onTap: () async {
                debugPrint("che");
                String? profession = await HomeBottomsheet.profession(
                  context,
                  _professionController,
                  () {
                    print("Next pressed for profession");
                  },
                );
                print("Selected profession: $profession");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _jobCard extends StatelessWidget {
  const _jobCard({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return CustomShadowContainer(
      horMargin: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: title,
                  style: const TextStyle(
                    color: AppPalette.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  _jobDetailBottomSheet(context);
                },
                child: const CustomImageView(
                  imagePath: MediaRes.settingGearIcon,
                  width: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CustomText(
                text: price,

                style: const TextStyle(
                  color: AppPalette.greyDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EmployeHomeCard(text: "Подробнее", isSelected: true),
              Row(
                spacing: 2,
                children: [
                  Icon(Icons.remove_red_eye),
                  CustomText(text: "19K"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _jobDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // если нужно на весь экран
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Егорова Ирина", //  "Job Title",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Работаю как UX/UI дизайнер, занимаюсь графическим дизайном и иллюстрацией. Высшее образование получила в Алматинском технологическом университете, училась там с 2014 по 2018 год, диплом у меня в PDF, могу прикрепить при необходимости.",

                // "Company Name • Location",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              const CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Связаться",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomImageView(imagePath: MediaRes.send, width: 24),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Добавить в избранное",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomImageView(imagePath: MediaRes.star, width: 24),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Отправить жалобу", // report
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.error,
                      ),
                    ),
                    CustomImageView(
                      imagePath: MediaRes.warningCircle,
                      width: 24,
                      color: AppPalette.error,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
            ],
          ),
        );
      },
    );
  }
}
