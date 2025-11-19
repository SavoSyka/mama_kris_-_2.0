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
  double dynamicMax = 1000; // initial slider max

  await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            Timer? debounce;

            // Apply filter
            void applyFilter() {
              if (showByAgreement) {
                result = {'agreement': true};
              } else {
                final double? from = double.tryParse(fromCtrl.text);
                final double? to = double.tryParse(toCtrl.text);

                int min, max;
                if (from != null && to != null && from <= to) {
                  min = from.round();
                  max = to.round();
                } else {
                  min = currentSlider.start.round();
                  max = currentSlider.end.round();
                }

                result = {'min': min, 'max': max};
              }
              Navigator.pop(ctx, result);
            }

            // Update FROM FIELD

            void onFromChanged(String val) {
              if (debounce?.isActive ?? false) debounce!.cancel();

              debounce = Timer(const Duration(milliseconds: 300), () {
                double? from = double.tryParse(fromCtrl.text);
                double? to = double.tryParse(toCtrl.text);

                if (from == null || from < 0) from = 0;

                setModalState(() {
                  // if from > to → pull "to" upward
                  if (to != null && from! > to!) {
                    to = from;
                    toCtrl.text = to!.round().toString();
                  }

                  fromCtrl.text = from!.round().toString();

                  currentSlider = RangeValues(
                    from.clamp(0, dynamicMax),
                    currentSlider.end.clamp(from, dynamicMax),
                  );
                });
              });
            }

            void onToChanged(String val) {
              if (debounce?.isActive ?? false) debounce!.cancel();
              debounce = Timer(const Duration(milliseconds: 300), () {
                final toValue = double.tryParse(toCtrl.text) ?? 0;
                final fromValue = double.tryParse(fromCtrl.text) ?? 0;

                setModalState(() {
                  // Expand max if needed
                  if (toValue > dynamicMax) dynamicMax = toValue;
                  if (fromValue > dynamicMax) dynamicMax = fromValue;

                  // Enforce from <= to
                  final validFrom = fromValue < toValue ? fromValue : toValue;
                  final validTo = toValue > fromValue ? toValue : fromValue;

                  currentSlider = RangeValues(
                    validFrom.clamp(0, dynamicMax),
                    validTo.clamp(0, dynamicMax),
                  );

                  fromCtrl.text = currentSlider.start.round().toString();
                  toCtrl.text = currentSlider.end.round().toString();
                });
              });
            }

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // close button
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: 'Поиск по фильтрам',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Text fields
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(ctx).size.width * 0.3,
                                    child: CustomInputText(
                                      hintText: 'Текст',
                                      labelText: 'От(₽)',
                                      controller: fromCtrl,
                                      keyboardType: TextInputType.number,
                                      onChanged: onFromChanged,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(ctx).size.width * 0.3,
                                    child: CustomInputText(
                                      hintText: 'Текст',
                                      labelText: 'До(₽)',
                                      controller: toCtrl,
                                      keyboardType: TextInputType.number,
                                      onChanged: onToChanged,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Slider
                              RangeSlider(
                                values: currentSlider,
                                min: 0,
                                max: dynamicMax,
                                divisions: dynamicMax > 100
                                    ? dynamicMax.round()
                                    : 100,
                                labels: RangeLabels(
                                  currentSlider.start.round().toString(),
                                  currentSlider.end.round().toString(),
                                ),
                                onChanged: (values) {
                                  setModalState(() {
                                    if (values.end > dynamicMax) {
                                      dynamicMax = values.end;
                                    }
                                    currentSlider = RangeValues(
                                      values.start.clamp(0, dynamicMax),
                                      values.end.clamp(0, dynamicMax),
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

                              const Text(
                                'Зарплата',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // checkbox
                              Row(
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
                                      text:
                                          "Показывать вакансии “по договоренности”",
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // button
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
        );
      },
    ),
  );

  return result;
}
