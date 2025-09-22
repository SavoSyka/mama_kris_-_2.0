import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/entity/job_model.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/applicant_home/presentation/widget/job_list.dart';
import 'package:mama_kris/features/home/presentation/widgets/add_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/empty_posted_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/home_bottomsheet/profession_bottomsheet.dart';

class ApplicantHomePage extends StatefulWidget {
  const ApplicantHomePage({super.key});

  @override
  State<ApplicantHomePage> createState() => _ApplicantHomePageState();
}

class _ApplicantHomePageState extends State<ApplicantHomePage> {
  final List<String> _tabList = [
    AppTextContents.active,
    AppTextContents.drafts,
    AppTextContents.archive,
  ];

  bool isList = false;
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

    debugPrint("Jobs ${_allJobs.length}");
  }

  final Map<String, String> _tabStatusMap = {
    'Активные': 'active',
    'Черновики': 'draft',
    'Архив': 'archived',
  };

  List<JobModel> get filteredJobs {
    return _allJobs;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
          ),
        ),
        child: SafeArea(
          child: Column(
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

              // Search Field
              GestureDetector(
                onTap: () {
                  _openSearchBottomSheet(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CustomText(text: AppTextContents.search),
                      ),
                      CustomImageView(imagePath: MediaRes.search, width: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// buttons filter buttons
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _Cards(
                          imagePath: MediaRes.slider,
                          text: AppTextContents.slider,

                          color: !isList
                              ? AppPalette.primaryColor
                              : AppPalette.white,
                          iconColor: !isList
                              ? AppPalette.white
                              : AppPalette.grey,
                          onTap: () {
                            setState(() {
                              isList = false;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        _Cards(
                          imagePath: MediaRes.slider,
                          text: AppTextContents.list,
                          color: isList
                              ? AppPalette.primaryColor
                              : AppPalette.white,
                          iconColor: isList
                              ? AppPalette.white
                              : AppPalette.grey,
                          onTap: () {
                            setState(() {
                              isList = true;
                            });
                          },
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final filterResult = _openFilterBottomSheet(
                              context,
                              ["Developer", "Designer", "Manager", "Tester"],
                            );

                            // if (filterResult != null) {
                            //   print("Price range: ${filterResult['priceRange']}");
                            //   print(
                            //     "Selected jobs: ${filterResult['selectedJobs']}",
                            //   );
                            // }
                          },
                          child: const CustomImageView(
                            imagePath: MediaRes.btnFilter,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // JobList(jobs: _allJobs),
              Expanded(child: JobList(jobs: _allJobs, isList: isList)),

              // const EmptyPostedJob(),
              // SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context, List<String> jobList) {
    double minPrice = 20.00;
    double maxPrice = 145.00;
    RangeValues priceRange = RangeValues(minPrice, maxPrice);

    // track selected jobs
    List<String> selectedJobs = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              minChildSize: 0.45,
              maxChildSize: 0.75,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const Text(
                        "Filter Jobs",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price Range
                      const Text("Price Range"),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          CustomText(
                            text: "от ${priceRange.start.toInt()} руб",
                          ),
                          CustomText(text: "до ${priceRange.end.toInt()} руб"),
                        ],
                      ),
                      RangeSlider(
                        padding: EdgeInsets.zero,
                        values: priceRange,
                        min: minPrice,
                        max: maxPrice,
                        divisions: 20,
                        labels: RangeLabels(
                          "от ${priceRange.start.toInt()} руб",
                          "до ${priceRange.end.toInt()} руб",
                        ),
                        onChanged: (values) {
                          setState(() {
                            priceRange = values;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Job list selection
                      const Text("Select Jobs"),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: jobList.map((job) {
                          final isSelected = selectedJobs.contains(job);
                          return ChoiceChip(
                            label: CustomText(
                              text: job,
                              style: TextStyle(
                                color: isSelected
                                    ? AppPalette.white
                                    : AppPalette.black,
                              ),
                            ),
                            checkmarkColor: AppPalette.white,
                            selected: isSelected,
                            selectedColor: Theme.of(context).primaryColor,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedJobs.add(job);
                                } else {
                                  selectedJobs.remove(job);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      CustomPrimaryButton(
                        btnText: 'Apply filters',
                        onTap: () {
                          Navigator.pop(context, {
                            'priceRange': priceRange,
                            'selectedJobs': selectedJobs,
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openSearchBottomSheet(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    // Example recent searches (you can fetch from sharedPrefs or DB later)
    final List<String> recentSearches = [
      "Flutter",
      "Удалённая работа",
      "Frontend",
      "Design",
      "Design",
      "Design",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3), // dim background
      builder: (context) {
        return DraggableScrollableSheet(
          expand: true,
          initialChildSize: 1, // full screen
          minChildSize: 0.7,
          maxChildSize: 1,
          builder: (_, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.white.withOpacity(0.7), // glassmorphic look
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      TextField(
                        controller: searchController,
                        autofocus: true, // open keyboard immediately
                        decoration: InputDecoration(
                          hintText: AppTextContents.search,
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Recent Searches Section
                      if (recentSearches.isNotEmpty) ...[
                        const Text(
                          "Recent searches",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: recentSearches.map((search) {
                            return Chip(
                              label: CustomText(text: search),
                              side: BorderSide.none,
                              deleteIcon: const Icon(Icons.close, size: 16),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide.none,
                              ),

                              onDeleted: () {
                                recentSearches.remove(search);
                                (context as Element).markNeedsBuild();
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Results
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 20, // example search results
                          itemBuilder: (_, index) => ListTile(
                            title: Text("Search Result $index"),
                            onTap: () {
                              Navigator.pop(context, "Search Result $index");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({
    super.key,
    this.imagePath,
    this.text,
    this.color,
    this.iconColor,
    this.onTap,
  });
  final String? imagePath;
  final String? text;
  final Color? color;
  final Color? iconColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color ?? AppPalette.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            if (imagePath != null)
              CustomImageView(
                imagePath: imagePath,
                width: 12,
                color: iconColor ?? AppPalette.grey,
              ),
            if (text != null)
              CustomText(
                text: text!,
                style: TextStyle(
                  color: iconColor ?? AppPalette.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
