import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/search_field.dart';

class ResumeTab extends StatefulWidget {
  const ResumeTab({super.key});

  @override
  State<ResumeTab> createState() => _ResumeTabState();
}

class _ResumeTabState extends State<ResumeTab> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const CustomText(
            text: AppTextContents.favoriteResumes,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          // search starts
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 16.w,
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    onChanged: (value) {
                      // логика поиска
                    },
                  ),
                ),

                const CustomImageView(imagePath: MediaRes.btnFilter, width: 64),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // job listing strat shere
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 20),

              itemBuilder: (context, index) => const _favJobCard(),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _favJobCard extends StatelessWidget {
  const _favJobCard();

  @override
  Widget build(BuildContext context) {
    return CustomShadowContainer(
      horMargin: 16,
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
