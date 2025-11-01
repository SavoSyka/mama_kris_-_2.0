// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
// import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
// import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
// import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
// import 'package:mama_kris/core/common/widgets/custom_text.dart';
// import 'package:mama_kris/core/constants/app_palette.dart';
// import 'package:mama_kris/core/constants/app_text_contents.dart';
// import 'package:mama_kris/core/constants/media_res.dart';
// import 'package:mama_kris/core/services/routes/route_name.dart';
// import 'package:mama_kris/features/applicant_profile/presentation/widget/applicant_profile_bottomsheet.dart';
// import 'package:mama_kris/features/employe_profile/presentation/widget/employe_profile_bottomsheet.dart';
// import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';

// class ApplicantProfilePage extends StatefulWidget {
//   const ApplicantProfilePage({super.key});

//   @override
//   State<ApplicantProfilePage> createState() => _ApplicantProfilePageState();
// }

// class _ApplicantProfilePageState extends State<ApplicantProfilePage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController oldPassword = TextEditingController();
//   final TextEditingController newPassword = TextEditingController();
//   final TextEditingController confrimPassword = TextEditingController();

//   final nameKey = GlobalKey<FormState>();
//   final emailKey = GlobalKey<FormState>();

//   final descriptionKeyey = GlobalKey<FormState>();

//   final myDescription =
//       "Я руковожу компанией среднего масштаба, которая уже несколько лет стабильно работает на рынке. Для меня важно сочетать устойчивость и развитие: мы не гонимся за быстрыми результатами, а строим долгосрочные отношения с клиентами и партнёрами. Основное внимание уделяю качеству услуг и оптимизации процессов, чтобы команда могла работать эффективно, а клиенты видели в нас надёжного партнёра.";
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),

//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
//           ),
//         ),
//         child: SafeArea(
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: "Мой профиль",
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 CustomText(
//                   text: "Кристина Гордова",
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppPalette.primaryColor,
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 CustomText(
//                   text: "23.08.1999 (26 лет)",
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF596574),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       spacing: 20,

//                       children: [
//                         CustomShadowContainer(
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const CustomText(
//                                     text: "Специализация",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       nameController.text = "Yaroslav Gordov";
//                                       EmployeProfileBottomsheet.nameBottoSheet(
//                                         context,
//                                         onNext: () {},
//                                         controller: nameController,
//                                         formKey: nameKey,
//                                       );
//                                     },
//                                     child: const CustomImageView(
//                                       imagePath: MediaRes.editBtn,
//                                       width: 24,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               const Row(
//                                 spacing: 16,
//                                 children: [
//                                   EmployeHomeCard(
//                                     text: 'Дизайнер',
//                                     isSelected: false,
//                                   ),

//                                   EmployeHomeCard(
//                                     text: 'Маркетолог',
//                                     isSelected: false,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         CustomShadowContainer(
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const CustomText(
//                                     text: "Образование",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       nameController.text = "Yaroslav Gordov";
//                                       EmployeProfileBottomsheet.nameBottoSheet(
//                                         context,
//                                         onNext: () {},
//                                         controller: nameController,
//                                         formKey: nameKey,
//                                       );
//                                     },
//                                     child: const CustomImageView(
//                                       imagePath: MediaRes.editBtn,
//                                       width: 24,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 spacing: 16,
//                                 children: [
//                                   EmployeHomeCard(
//                                     text:
//                                         'Московский технологический университет',
//                                     isSelected: false,
//                                   ),

//                                   EmployeHomeCard(
//                                     text: 'Курс Design Studio “LimeLight”',
//                                     isSelected: false,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         CustomShadowContainer(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const CustomText(
//                                     text: "Опыт работы",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       nameController.text = "Yaroslav Gordov";
//                                       EmployeProfileBottomsheet.nameBottoSheet(
//                                         context,
//                                         onNext: () {},
//                                         controller: nameController,
//                                         formKey: nameKey,
//                                       );
//                                     },
//                                     child: const CustomImageView(
//                                       imagePath: MediaRes.editBtn,
//                                       width: 24,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF9F9F9),

//                                   borderRadius: BorderRadius.circular(5),
//                                 ),

//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,

//                                   children: [
//                                     CustomText(
//                                       text: 'Creative Agency “PixelCraft',
//                                       style: TextStyle(
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),

//                                     CustomText(
//                                       text: '12.09.2023 - 11.12.2025',
//                                       style: TextStyle(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         CustomShadowContainer(
//                           child: Column(
//                             spacing: 16,

//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const CustomText(
//                                     text: AppTextContents.changePwd,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),

//                                   GestureDetector(
//                                     onTap: () {
//                                       oldPassword.clear();
//                                       newPassword.clear();
//                                       confrimPassword.clear();


//                                       // ApplicantProfileBottomsheet.changePassword(
//                                       //   context,
//                                       //   onNext: () {},
//                                       //   oldPassword: oldPassword,
//                                       //   newPassword: newPassword,
//                                       //   confirmPassword: confrimPassword,

//                                       //   formKey: nameKey,
//                                       // );
//                                     },
//                                     child: const CustomImageView(
//                                       imagePath: MediaRes.editBtn,
//                                       width: 24,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                           CustomPrimaryButton(
//                 btnText: "Выход",
//                 onTap: () {
//                   context.goNamed(RouteName.welcomePage);
//                 },
//               ),

//                         const SizedBox(height: 32),

//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ApplicantProfilePage extends StatelessWidget {
  const ApplicantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}