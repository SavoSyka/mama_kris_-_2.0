import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

/// Returns:
///   - {'min': 150, 'max': 1200}   // from text fields or slider
///   - {'agreement': true}         // if "по договоренности" is checked
///   - null                        // if dismissed
Future<Map<String, dynamic>?> ApplicantJobFilter(BuildContext context) async {
  // --- state that survives the modal ---
  final RangeValues initialSlider = const RangeValues(20, 1000);
  RangeValues currentSlider = initialSlider;

  final TextEditingController fromCtrl = TextEditingController(
    text: initialSlider.start.round().toString(),
  );
  final TextEditingController toCtrl = TextEditingController(
    text: initialSlider.end.round().toString(),
  );

  bool showByAgreement = false;
  Map<String, dynamic>? result;

  await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: true,
    builder: (_) => StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setModalState) {
        void applyFilter() {
          if (showByAgreement) {
            result = {'agreement': true};
          } else {
            // 1. Try text fields first
            final double? from = double.tryParse(fromCtrl.text);
            final double? to = double.tryParse(toCtrl.text);

            int min, max;
            if (from != null && to != null && from <= to) {
              min = from.round();
              max = to.round();
            } else {
              // 2. Fallback to slider
              min = currentSlider.start.round();
              max = currentSlider.end.round();
            }

            result = {'min': min, 'max': max};
          }

          // Print exactly what you want
          if (result!['agreement'] == true) {
            debugPrint('User selected: по договоренности');
          } else {
            debugPrint('User selected: ${result!['min']}-${result!['max']}');
          }

          Navigator.pop(ctx, result);
        }

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      child: const CustomImageView(
                        imagePath: MediaRes.modalCloseIcon,
                        width: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // White container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 20),
                          // Text fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.3,
                                child: CustomInputText(
                                  hintText: 'Текст',
                                  labelText: 'От',
                                  controller: fromCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.3,
                                child: CustomInputText(
                                  hintText: 'Текст',
                                  labelText: 'До',
                                  controller: toCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Slider
                          RangeSlider(
                            values: currentSlider,
                            min: 0,
                            max: 1000,
                            divisions: 10,
                            labels: RangeLabels(
                              currentSlider.start.round().toString(),
                              currentSlider.end.round().toString(),
                            ),
                            onChanged: (newValues) {
                              currentSlider = newValues;
                              setModalState(() {});
                            },
                          ),
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
                          // Checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => setModalState(() {
                                  showByAgreement = !showByAgreement;
                                }),
                                child: Image.asset(
                                  showByAgreement
                                      ? MediaRes.markedBox
                                      : MediaRes.unMarkedBox,
                                  width: 28,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: CustomText(
                                  text: "Показывать вакансии “по договоренности”",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Apply button
                          CustomButtonApplicant(
                            btnText: 'Найти',
                            onTap: applyFilter,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return result;
}