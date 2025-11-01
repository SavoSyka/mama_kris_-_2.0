import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

Future<String?> ResumeFilter(BuildContext context) {
  
  
  GlobalKey menuKey = GlobalKey();

   RangeValues currentRangeValues = const RangeValues(20, 1000); 

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: true,

    builder: (BuildContext context) {
      bool showVacancyByAgreemenet = false;
      return StatefulBuilder(
        builder: (context, useState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SizedBox(
              // height: MediaQuery.sizeOf(context).height ,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const CustomImageView(
                            imagePath: MediaRes.modalCloseIcon,
                            width: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              const CustomText(
                                text: 'Поиск по фильтрам',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.30,
                                ),
                              ),

                              const SizedBox(height: 50),
                              CustomInputText(
                                hintText: 'Специальность',
                                labelText: 'Специальность',
                                controller: TextEditingController(),
                              ),
                              const SizedBox(height: 16),
                              // seeting salry
                              const Text(
                                'Зарплата',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.30,
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.3,
                                    child: CustomInputText(
                                      hintText: 'Текст',
                                      labelText: 'От',

                                      controller: TextEditingController(),
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.3,
                                    child: CustomInputText(
                                      hintText: 'Текст',
                                      labelText: 'До',

                                      controller: TextEditingController(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              RangeSlider(
                                values: currentRangeValues,
                                min: 0,
                                max: 1000,
                                divisions:
                                    10,
                                labels: RangeLabels(
                                  currentRangeValues.start.round().toString(),
                                  currentRangeValues.end.round().toString(),
                                ),
                                onChanged: (RangeValues newValues) {
                                  useState(() {
                                    currentRangeValues = newValues;
                                  });
                                },
                              ),

                              const SizedBox(height: 32),


                              const CustomButtonApplicant(btnText: 'Найти'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _contactCard({required String label, required String icon}) {
  return Row(
    children: [
      Center(child: CustomText(text: label)),
      CustomImageView(imagePath: icon, width: 32),
    ],
  );
}

void _showJobOptionsMenu(BuildContext context, GlobalKey menuKey) {
  final RenderBox renderBox =
      menuKey.currentContext!.findRenderObject() as RenderBox;
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
