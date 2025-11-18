import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';


Future<Map<String, dynamic>?> EmployeResumesFilter(BuildContext context) async {
  const double MIN_AGE = 10;
  const double MAX_AGE = 100;

  RangeValues currentSlider = const RangeValues(MIN_AGE, MAX_AGE);

  final TextEditingController fromCtrl =
      TextEditingController(text: MIN_AGE.round().toString());
  final TextEditingController toCtrl =
      TextEditingController(text: MAX_AGE.round().toString());

  Map<String, dynamic>? result;

  await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setModalState) {
        Timer? debounce;

        void applyFilter() {
          final double? from = double.tryParse(fromCtrl.text);
          final double? to = double.tryParse(toCtrl.text);

          int min, max;
          if (from != null &&
              to != null &&
              from >= MIN_AGE &&
              to <= MAX_AGE &&
              from <= to) {
            min = from.round();
            max = to.round();
          } else {
            min = currentSlider.start.round();
            max = currentSlider.end.round();
          }

          result = {'min': min, 'max': max};
          Navigator.pop(ctx, result);
        }

        // FROM FIELD CHANGE
        void onFromChanged(String val) {
          if (debounce?.isActive ?? false) debounce!.cancel();

          debounce = Timer(const Duration(milliseconds: 300), () {
            double from = double.tryParse(fromCtrl.text) ?? MIN_AGE;
            double to = double.tryParse(toCtrl.text) ?? MAX_AGE;

            from = from.clamp(MIN_AGE, MAX_AGE);
            to = to.clamp(MIN_AGE, MAX_AGE);

            setModalState(() {
              if (from > to) {
                to = from;
                toCtrl.text = to.round().toString();
              }

              fromCtrl.text = from.round().toString();

              currentSlider = RangeValues(from, to);
            });
          });
        }

        // TO FIELD CHANGE
        void onToChanged(String val) {
          if (debounce?.isActive ?? false) debounce!.cancel();

          debounce = Timer(const Duration(milliseconds: 300), () {
            double from = double.tryParse(fromCtrl.text) ?? MIN_AGE;
            double to = double.tryParse(toCtrl.text) ?? MAX_AGE;

            from = from.clamp(MIN_AGE, MAX_AGE);
            to = to.clamp(MIN_AGE, MAX_AGE);

            setModalState(() {
              if (to < from) {
                from = to;
                fromCtrl.text = from.round().toString();
              }

              toCtrl.text = to.round().toString();

              currentSlider = RangeValues(from, to);
            });
          });
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
                  children: const [
                    CustomImageView(
                      imagePath: MediaRes.modalCloseIcon,
                      width: 32,
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(36)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.3,
                                child: CustomInputText(
                                  hintText: '',
                                  labelText: 'От',
                                  controller: fromCtrl,
                                  keyboardType: TextInputType.number,
                                  onChanged: onFromChanged,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.3,
                                child: CustomInputText(
                                  hintText: '',
                                  labelText: 'До',
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
                            min: MIN_AGE,
                            max: MAX_AGE,
                            divisions: (MAX_AGE - MIN_AGE).toInt(),
                            labels: RangeLabels(
                              currentSlider.start.round().toString(),
                              currentSlider.end.round().toString(),
                            ),
                            onChanged: (values) {
                              setModalState(() {
                                currentSlider = RangeValues(
                                  values.start.clamp(MIN_AGE, MAX_AGE),
                                  values.end.clamp(MIN_AGE, MAX_AGE),
                                );

                                fromCtrl.text =
                                    currentSlider.start.round().toString();
                                toCtrl.text =
                                    currentSlider.end.round().toString();
                              });
                            },
                          ),

                          const SizedBox(height: 16),

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
