import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/employe_profile/presentation/widget/employe_profile_bottomsheet.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';

class EmployeProfilePage extends StatefulWidget {
  const EmployeProfilePage({super.key});

  @override
  State<EmployeProfilePage> createState() => _EmployeProfilePageState();
}

class _EmployeProfilePageState extends State<EmployeProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final nameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();

  final descriptionKeyey = GlobalKey<FormState>();

  final myDescription =
      "Я руковожу компанией среднего масштаба, которая уже несколько лет стабильно работает на рынке. Для меня важно сочетать устойчивость и развитие: мы не гонимся за быстрыми результатами, а строим долгосрочные отношения с клиентами и партнёрами. Основное внимание уделяю качеству услуг и оптимизации процессов, чтобы команда могла работать эффективно, а клиенты видели в нас надёжного партнёра.";
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
            child: CustomImageView(imagePath: MediaRes.btnFilter, width: 64),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: CustomDefaultPadding(
          child: Column(
            spacing: 20,
            children: [
              CustomShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Yaroslav Gordov",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        nameController.text = "Yaroslav Gordov";
                        EmployeProfileBottomsheet.nameBottoSheet(
                          context,
                          onNext: () {},
                          controller: nameController,
                          formKey: nameKey,
                        );
                      },
                      child: const CustomImageView(
                        imagePath: MediaRes.editBtn,
                        width: 24,
                      ),
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
                        const CustomText(
                          text: AppTextContents.contactInfo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            EmployeProfileBottomsheet.showContactBottomSheet(
                              context,
                              telegram: "yarovak",
                              vk: "vk.com/yarovak",
                              whatsapp: "+123456789",
                              onSave: (telegram, vk, whatsapp) {
                                debugPrint(
                                  "Updated: $telegram, $vk, $whatsapp",
                                );
                                // Update state or call Bloc event here
                              },
                            );
                          },
                          child: const CustomImageView(
                            imagePath: MediaRes.editBtn,
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    const Row(
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
                        const CustomText(
                          text: AppTextContents.myEmail,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            emailController.text = "yaroslaw@gmail.com";
                            EmployeProfileBottomsheet.emailBottomshet(
                              context,
                              onNext: () {},
                              controller: emailController,
                              formKey: nameKey,
                            );
                          },
                          child: const CustomImageView(
                            imagePath: MediaRes.editBtn,
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    const Row(
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
                        const CustomText(
                          text: AppTextContents.descriptionOf,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            descriptionController.text = myDescription;
                            EmployeProfileBottomsheet.descriptionBottomSheet(
                              context,
                              onNext: () {},
                              controller: descriptionController,
                              formKey: descriptionKeyey,
                            );
                          },
                          child: const CustomImageView(
                            imagePath: MediaRes.editBtn,
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    CustomText(text: myDescription),
                  ],
                ),
              ),

              CustomPrimaryButton(
                btnText: "Выход",
                onTap: () {
                  context.goNamed(RouteName.welcomePage);
                },
                isSecondaryPrimary: true,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
