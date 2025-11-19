import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

Future<Map<String, dynamic>?> ApplicantJobFilter(BuildContext context) async {
  const RangeValues initialSlider = RangeValues(20, 1000);
  RangeValues currentSlider = initialSlider;

  final TextEditingController fromCtrl = TextEditingController(
    text: initialSlider.start.round().toString(),
  );
  final TextEditingController toCtrl = TextEditingController(
    text: initialSlider.end.round().toString(),
  );

  bool showByAgreement = false;
  Map<String, dynamic>? result;
  double dynamicMax = 1000.0;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            Timer? debounce;

            void applyFilter() {
              if (showByAgreement) {
                result = {'agreement': true};
              } else {
                final from = double.tryParse(fromCtrl.text);
                final to = double.tryParse(toCtrl.text);

                int min = currentSlider.start.round();
                int max = currentSlider.end.round();

                if (from != null && to != null && from <= to) {
                  min = from.round();
                  max = to.round();
                }

                result = {'min': min, 'max': max};
              }
              Navigator.pop(context, result);
            }

            void onFromChanged(String value) {
              if (debounce?.isActive ?? false) debounce!.cancel();
              debounce = Timer(const Duration(milliseconds: 300), () {
                final fromValue = double.tryParse(fromCtrl.text) ?? 0;
                final toValue =
                    double.tryParse(toCtrl.text) ?? currentSlider.end;

                setModalState(() {
                  if (fromValue > toValue) {
                    toCtrl.text = fromValue.round().toString();
                    currentSlider = RangeValues(fromValue, fromValue);
                  } else {
                    currentSlider = RangeValues(fromValue, currentSlider.end);
                  }

                  // Expand max if needed
                  if (fromValue > dynamicMax) dynamicMax = fromValue;

                  currentSlider = RangeValues(
                    currentSlider.start.clamp(0, dynamicMax),
                    currentSlider.end.clamp(currentSlider.start, dynamicMax),
                  );

                  fromCtrl.text = currentSlider.start.round().toString();
                  toCtrl.text = currentSlider.end.round().toString();
                });
              });
            }

            void onToChanged(String value) {
              if (debounce?.isActive ?? false) debounce!.cancel();
              debounce = Timer(const Duration(milliseconds: 300), () {
                final toValue = double.tryParse(toCtrl.text) ?? 0;
                final fromValue =
                    double.tryParse(fromCtrl.text) ?? currentSlider.start;

                setModalState(() {
                  if (toValue > dynamicMax) {
                    dynamicMax = toValue;
                  }

                  if (toValue < fromValue) {
                    fromCtrl.text = toValue.round().toString();
                    currentSlider = RangeValues(toValue, toValue);
                  } else {
                    currentSlider = RangeValues(currentSlider.start, toValue);
                  }

                  currentSlider = RangeValues(
                    currentSlider.start.clamp(0, dynamicMax),
                    currentSlider.end.clamp(currentSlider.start, dynamicMax),
                  );

                  fromCtrl.text = currentSlider.start.round().toString();
                  toCtrl.text = currentSlider.end.round().toString();
                });
              });
            }

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    // Header + Close
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const CustomImageView(
                              imagePath: MediaRes.modalCloseIcon,
                              width: 32,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText(
                        text: 'Поиск по фильтрам',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Salary Fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: CustomInputText(
                                    labelText: 'От(₽)',
                                    hintText: '0',
                                    controller: fromCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: onFromChanged,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: CustomInputText(
                                    labelText: 'До(₽)',
                                    hintText: '1000+',
                                    controller: toCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: onToChanged,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Range Slider
                            RangeSlider(
                              values: currentSlider,
                              min: 0,
                              max: dynamicMax,
                              divisions: dynamicMax > 100
                                  ? dynamicMax.round()
                                  : 100,
                              labels: RangeLabels(
                                '${currentSlider.start.round()}',
                                '${currentSlider.end.round()}',
                              ),
                              onChanged: (RangeValues values) {
                                setModalState(() {
                                  if (values.end > dynamicMax) {
                                    dynamicMax = values.end;
                                  }
                                  currentSlider = RangeValues(
                                    values.start.clamp(0, dynamicMax),
                                    values.end.clamp(values.start, dynamicMax),
                                  );
                                  fromCtrl.text = currentSlider.start
                                      .round()
                                      .toString();
                                  toCtrl.text = currentSlider.end
                                      .round()
                                      .toString();
                                });
                              },
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              'Зарплата',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Checkbox
                            InkWell(
                              onTap: () => setModalState(() {
                                showByAgreement = !showByAgreement;
                              }),
                              child: Row(
                                children: [
                                  Image.asset(
                                    showByAgreement
                                        ? MediaRes.markedBox
                                        : MediaRes.unMarkedBox,
                                    width: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: CustomText(
                                      text:
                                          "Показывать вакансии “по договоренности”",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Apply Button
                            CustomButtonApplicant(
                              btnText: 'Найти',
                              onTap: applyFilter,
                            ),

                            const SizedBox(height: 20),
                          ],
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
    ),
  );

  return result;
}
