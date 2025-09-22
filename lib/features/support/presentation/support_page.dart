import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/entity/job_model.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/search_field.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  List<JobModel> _allJobs = [];

  Future<void> loadJobs() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/job.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _allJobs = jsonData.map((e) => JobModel.fromJson(e)).toList();
    });

    debugPrint("Jobs");
  }

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
                  text: AppTextContents.favoriteResumes,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Dismissible(
                        key: ValueKey(filteredJobs[index].id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            filteredJobs.removeAt(index);
                            // jobs.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Deleted}")),
                          );
                        },

                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: Colors.white, size: 28),

                              CustomText(
                                text: "Delete",
                                style: TextStyle(
                                  color: AppPalette.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        child: const _favJobCard(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _favJobCard extends StatelessWidget {
  const _favJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            children: [
              const Expanded(
                child: CustomText(
                  text: "Егорова Ирина",
                  style: TextStyle(
                    color: AppPalette.secondaryColor,
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
          const Row(
            children: [
              EmployeHomeCard(text: "Дизайнер", isSelected: false),
              CustomText(text: "19 лет"),
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
