import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_bottom_sheet_header.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/utils/form_validations.dart';

class CustomDateInput extends StatefulWidget {
  const CustomDateInput({
    super.key,
    required this.controller,
    this.isRequired = false,
    required this.label,
    this.validator,
    this.isApplicant = false,
  });

  final TextEditingController controller;
  final bool isRequired;
  final String label;
  final bool isApplicant;
  final FormFieldValidator<String>? validator;

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Load saved backend format yyyy-MM-dd
    if (widget.controller.text.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
      } catch (_) {
        _selectedDate = null;
      }
    }
  }

  Future<void> showBirthDateDialog() async {
    final now = DateTime.now();
    final maxYear = now.year;

    DateTime selectedDate;

    // Parse controller value (backend format)
    if (widget.controller.text.isNotEmpty) {
      try {
        selectedDate = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
        // Ensure selectedDate is not in the future
        if (selectedDate.isAfter(now)) {
          selectedDate = now;
        }
      } catch (_) {
        selectedDate = DateTime(maxYear);
      }
    } else {
      selectedDate = DateTime(maxYear);
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomBottomSheetHeader(
                    title: 'Выберите дату рождения',
                    onClose: () => Navigator.pop(context),
                  ),

                  SizedBox(
                    height: 200,
                    child: Localizations.override(
                      context: context,
                      locale: const Locale('ru', 'RU'),
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          minimumYear: 1900,
                          maximumYear: maxYear,
                          maximumDate: now,
                          onDateTimeChanged: (date) {
                            selectedDate = date;
                          },
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8, 16.w, 16.w),
                    child: 
                  widget.isApplicant ?

                    CustomButtonApplicant(
                      onTap: () {
                        final backend = DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate);

                        setState(() {
                          widget.controller.text = backend;
                        });

                        widget
                            .controller
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: widget.controller.text.length),
                        );

                        debugPrint(
                          "Saved to controller: ${widget.controller.text}",
                        );

                        Navigator.pop(context);
                      },
                      isLoading: false,
                      btnText: 'Set',
                    ):
                  
                    CustomButtonEmployee(
                      onTap: () {
                        final backend = DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate);

                        setState(() {
                          widget.controller.text = backend;
                        });

                        widget
                            .controller
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: widget.controller.text.length),
                        );

                        debugPrint(
                          "Saved to controller: ${widget.controller.text}",
                        );

                        Navigator.pop(context);
                      },
                      isLoading: false,
                      btnText: 'Set',
                    ),
                  
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      hintText: 'Выберите дату рождения',
      labelText: widget.label,
      controller: widget.controller,
      keyboardType: TextInputType.none,
      validator: widget.validator ?? FormValidations.validateDateOfBirth,
      suffixIcon: InkWell(
        onTap: showBirthDateDialog,
        child: Container(
          width: 12.w,
          height: 16.h,
          padding: const EdgeInsets.all(13),
          child: Image.asset(
            MediaRes.calendarIcon,
            width: 12.w,
            height: 16.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
      onTap: showBirthDateDialog,
    );
  }
}
