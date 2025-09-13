import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const CustomText(
          text: AppTextContents.myProfile,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,

        actions: const [
          InkWell(
            child: 
            CustomImageView(imagePath: MediaRes.btnFilter, width: 64),
          ),
        ],
      ),

      body: const SingleChildScrollView(
        child: CustomDefaultPadding(
          child: Column(
            spacing: 20,
            children: [
              CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Yaroslav Gordov",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomImageView(imagePath: MediaRes.editBtn, width: 24),
                  ],
                ),
              ),

              CustomShadowContainer(
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: AppTextContents.contactInfo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomImageView(imagePath: MediaRes.editBtn, width: 24),
                      ],
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        EmployeHomeCard(text: 'Telegram', isSelected: true),

                        EmployeHomeCard(text: 'VK', isSelected: true),
                        EmployeHomeCard(text: 'Whatsapp', isSelected: false),
                      ],
                    ),
                  ],
                ),
              ),

              CustomShadowContainer(
                child: Column(
                  spacing: 16,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: AppTextContents.myEmail,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomImageView(imagePath: MediaRes.editBtn, width: 24),
                      ],
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        EmployeHomeCard(
                          text: 'yaroslav@***@gmail.com',
                          isSelected: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              CustomShadowContainer(
                child: Column(
                  spacing: 16,

                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: AppTextContents.descriptionOf,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomImageView(imagePath: MediaRes.editBtn, width: 24),
                      ],
                    ),

                    CustomText(
                      text:
                          "Я руковожу компанией среднего масштаба, которая уже несколько лет стабильно работает на рынке. Для меня важно сочетать устойчивость и развитие: мы не гонимся за быстрыми результатами, а строим долгосрочные отношения с клиентами и партнёрами. Основное внимание уделяю качеству услуг и оптимизации процессов, чтобы команда могла работать эффективно, а клиенты видели в нас надёжного партнёра.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
