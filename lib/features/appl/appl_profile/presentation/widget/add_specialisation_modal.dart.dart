// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/show_ios_loader.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/speciality/speciality_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';

// Future<String?> AddSpecialisationModal(
//   BuildContext context, {
//   required List<String> speciality,
// }) {
//   final TextEditingController spec = TextEditingController();

//   return showModalBottomSheet<String>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     useSafeArea: true,
//     isDismissible: true,
//     builder: (BuildContext context) {
//       return BlocListener<ApplicantContactBloc, ApplicantContactState>(
//         listener: (context, state) {
//           if (state is ApplicantContactLoading) {}

//           if (state is SpecialityUpdatedState) {
//             Navigator.pop(context, spec.text);
//           }

//           if (state is ApplicantContactError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         child: BlocBuilder<ApplicantContactBloc, ApplicantContactState>(
//           builder: (context, state) {
//             return AnimatedPadding(
//               duration: const Duration(milliseconds: 200),
//               curve: Curves.easeOut,
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(36),
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: SingleChildScrollView(
//                       child: StatefulBuilder(
//                         builder: (context, useState) {
//                           return Column(
//                             children: [
//                               const CustomText(
//                                 text: "Выберите специальность",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),

//                               CustomInputText(
//                                 hintText: 'Специальность',
//                                 labelText: "Специальность",
//                                 controller: spec,
//                               ),

//                               const SizedBox(height: 24),

//                               CustomButtonApplicant(
//                                 isLoading: state is ApplicantContactLoading,
//                                 btnText: "Специальность",
//                                 onTap: () {
//                                   final value = spec.text.trim();
//                                   if (value.isEmpty) return;

//                                   speciality.add(value);

//                                   context.read<ApplicantContactBloc>().add(
//                                     CreateSpecialityEvent(
//                                       speciality: List.from(speciality),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 24),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

Future<List<String>?> AddSpecialisationModal(
  BuildContext context, {
  required List<String> speciality,
}) {
  final TextEditingController controller = TextEditingController();

  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider(
        create: (_) => sl<SpecialityBloc>(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: ClipRRect(
              child: _SpecialityBottomSheet(
                controller: controller,
                speciality: speciality,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _SpecialityBottomSheet extends StatefulWidget {
  final TextEditingController controller;
  final List<String> speciality;
  const _SpecialityBottomSheet({
    super.key,
    required this.controller,
    required this.speciality,
  });

  @override
  State<_SpecialityBottomSheet> createState() => _SpecialityBottomSheetState();
}

class _SpecialityBottomSheetState extends State<_SpecialityBottomSheet> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();

    super.dispose();
  }

  List<String> _selectedSpeciality = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedSpeciality.addAll(widget.speciality);
    });
    context.read<SpecialityBloc>().add(SearchSpecialityEvent(""));

    for (var item in _selectedSpeciality) {
      debugPrint("Adding speciality $item");
      context.read<SpecialityBloc>().add(AddSpecialityEvent(item));
    }

    debugPrint("_selectedSpeciality ${_selectedSpeciality.length}");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to ApplicantContactBloc to auto-pop on success
        BlocListener<ApplicantContactBloc, ApplicantContactState>(
          listener: (context, state) {
            if (state is SpecialityUpdatedState) {
              debugPrint(" before we pop, $_selectedSpeciality");
              Navigator.pop(context, _selectedSpeciality);
            } else if (state is ApplicantContactError) {
              // Optional: show error
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: BlocConsumer<SpecialityBloc, SpecialityState>(
        listener: (context, listenerState) {
          debugPrint("state updated");

          setState(() {
            _selectedSpeciality = listenerState.selected;
          });
          debugPrint("\n\nstate updated $_selectedSpeciality");
        },
        builder: (context, specialityState) {
          // Get the loading state from ApplicantContactBloc
          final bool isSaving = context.select<ApplicantContactBloc, bool>(
            (bloc) => bloc.state is ApplicantContactLoading,
          );

          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Selected Chips
                          Wrap(
                            spacing: 8,
                            children: specialityState.selected
                                .map(
                                  (s) => Chip(
                                    label: Text(s),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () => context
                                        .read<SpecialityBloc>()
                                        .add(RemoveSpecialityEvent(s)),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // Search Field
                          TextField(
                            controller: widget.controller,
                            decoration: const InputDecoration(
                              labelText: "Специальность",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              if (_debounceTimer?.isActive ?? false) {
                                _debounceTimer!.cancel();
                              }
                              _debounceTimer = Timer(
                                const Duration(milliseconds: 800),
                                () {
                                  context.read<SpecialityBloc>().add(
                                    SearchSpecialityEvent(val),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Suggestions
                          if (specialityState.loading)
                            const Center(child: CircularProgressIndicator())
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: specialityState.suggestions.length,
                              itemBuilder: (_, index) {
                                final item = specialityState.suggestions[index];
                                return ListTile(
                                  title: Text(item),
                                  onTap: () {
                                    context.read<SpecialityBloc>().add(
                                      AddSpecialityEvent(item),
                                    );
                                    widget.controller.clear();
                                  },
                                );
                              },
                            ),
                          const SizedBox(height: 20),

                          // Save Button with dynamic loading state
                        ],
                      ),
                    ),
                  ),

                  BlocBuilder<ApplicantContactBloc, ApplicantContactState>(
                    builder: (context, contactState) {
                      final bool isLoading =
                          contactState is ApplicantContactLoading;

                      return CustomButtonApplicant(
                        btnText: "Сохранить",
                        isLoading: isLoading,
                        onTap: isLoading
                            ? null
                            : () {
                                // if (specialityState.selected.isEmpty) return;
                                _selectedSpeciality = specialityState.selected;
                                // _selectedSpeciality.addAll(widget.speciality);
                                _selectedSpeciality.toSet().toList();

                                debugPrint(
                                  "We are sending this data $_selectedSpeciality",
                                );
                                context.read<ApplicantContactBloc>().add(
                                  CreateSpecialityEvent(
                                    speciality: _selectedSpeciality,
                                  ),
                                );
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
