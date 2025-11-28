import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'dart:ui';

import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';

Future<String?> AddSpecialisationModal(
  BuildContext context, {
  required List<String> speciality,
}) {
  final TextEditingController spec = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return BlocListener<ApplicantContactBloc, ApplicantContactState>(
        listener: (context, state) {
          if (state is ApplicantContactLoading) {
            // showIOSLoader(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  const Center(child: CupertinoActivityIndicator(radius: 20)),
            );
          }

          if (state is SpecialityUpdatedState) {
            Navigator.pop(context);
            context.pop({'spec': spec.text});
          }

          if (state is ApplicantContactError) {
            Navigator.pop(context); // close loading

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CustomText(
                        text: "Выберите специальность",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      CustomInputText(
                        hintText: 'Специальность',
                        labelText: "Специальность",
                        controller: spec,
                      ),

                      const SizedBox(height: 24),

                      CustomButtonApplicant(
                        btnText: "Добавить",
                        onTap: () {
                          final value = spec.text.trim();
                          if (value.isEmpty) return;

                          speciality.add(value);

                          context.read<ApplicantContactBloc>().add(
                            CreateSpecialityEvent(
                              speciality: List.from(speciality),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
