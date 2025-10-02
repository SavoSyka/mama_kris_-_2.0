import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_text_button.dart';
import 'package:mama_kris/core/common/widgets/custom_bottomsheet.dart';
import 'package:mama_kris/core/common/widgets/show_toast.dart';
import 'package:mama_kris/core/config/bottomsheet_config.dart';
import 'package:mama_kris/core/config/form_field_config.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/employe_home/applications/post_job/post_job_bloc.dart';
import 'package:mama_kris/features/employe_home/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/profession_entity.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/get_contacts_usecase.dart';
import 'package:mama_kris/features/employe_home/domain/usecases/get_professions_usecase.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';

class JobPostingBottomSheets {
  // Profession Selection Bottom Sheet
  static Future<bool> professionBottomSheet(BuildContext context) async {
    // Dummy data for now
    List<ProfessionEntity> professions = [
      const ProfessionEntity(id: '1', name: 'Software Developer'),
      const ProfessionEntity(id: '2', name: 'Designer'),
      const ProfessionEntity(id: '3', name: 'Manager'),
    ];

    String? selectedProfession;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomBottomSheet(
              title: 'Select Profession',
              fields: const [],
              buttonText: AppTextContents.next,
              formKey: GlobalKey<FormState>(),
              additionalWidgets: [
                Column(
                  children: professions.map((profession) {
                    return ListTile(
                      title: Text(profession.name),
                      onTap: () {
                        setState(() => selectedProfession = profession.name);
                      },
                      trailing: selectedProfession == profession.name
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                    );
                  }).toList(),
                ),
              ],
              onSubmit: () {
                if (selectedProfession != null) {
                  context.read<PostJobBloc>().add(
                    PostJobUpdateProfessionEvent(
                      profession: selectedProfession!,
                    ),
                  );
                  Navigator.pop(context, true);
                  // Navigate to next step
                  descriptionBottomSheet(context);
                } else {
                  showToast(context, message: 'Please select a profession');
                }
              },
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  // Job Description Bottom Sheet
  static Future<bool> descriptionBottomSheet(BuildContext context) async {
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CustomBottomSheet(
          title: 'Job Description',
          formKey: formKey,
          fields: [
            FormFieldConfig(
              hintText: 'Enter job description',
              controller: descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
          ],
          buttonText: AppTextContents.next,
          onSubmit: () {
            if (formKey.currentState!.validate()) {
              context.read<PostJobBloc>().add(
                PostJobUpdateDescriptionEvent(
                  description: descriptionController.text,
                ),
              );
              Navigator.pop(context, true);
              contactsBottomSheet(context);
            }
          },
        );
      },
    ).then((value) => value ?? false);
  }

  // Contacts Selection Bottom Sheet
  static Future<bool> contactsBottomSheet(BuildContext context) async {
    // Dummy data for now
    List<ContactEntity> contacts = [
      const ContactEntity(id: '1', name: 'Telegram', type: 'telegram'),
      const ContactEntity(id: '2', name: 'WhatsApp', type: 'whatsapp'),
      const ContactEntity(id: '3', name: 'Email', type: 'email'),
      const ContactEntity(id: '4', name: 'Phone', type: 'phone'),
      const ContactEntity(id: '5', name: 'VK', type: 'vk'),
    ];
    List<String> selectedContacts = [];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomBottomSheet(
              title: 'Select Contacts',
              fields: const [],
              buttonText: AppTextContents.next,
              formKey: GlobalKey<FormState>(),
              additionalWidgets: [
                Column(
                  children: contacts.map((contact) {
                    return CheckboxListTile(
                      title: Text('${contact.name} (${contact.type})'),
                      value: selectedContacts.contains(contact.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedContacts.add(contact.id);
                          } else {
                            selectedContacts.remove(contact.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              onSubmit: () {
                if (selectedContacts.isNotEmpty) {
                  context.read<PostJobBloc>().add(
                    PostJobUpdateContactsEvent(contacts: selectedContacts),
                  );
                  Navigator.pop(context, true);
                  salaryBottomSheet(context);
                } else {
                  showToast(
                    context,
                    message: 'Please select at least one contact',
                  );
                }
              },
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  // Salary Input Bottom Sheet
  static Future<bool> salaryBottomSheet(BuildContext context) async {
    final salaryController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool salaryByAgreement = false;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomBottomSheet(
              title: 'Salary',
              formKey: formKey,
              fields: [
                if (!salaryByAgreement)
                  FormFieldConfig(
                    hintText: 'Enter salary amount',
                    controller: salaryController,
                    validator: (value) {
                      if (!salaryByAgreement &&
                          (value == null || value.isEmpty)) {
                        return 'Salary is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
              ],
              buttonText: AppTextContents.next,
              additionalWidgets: [
                CheckboxListTile(
                  title: const Text('Salary by agreement'),
                  value: salaryByAgreement,
                  onChanged: (bool? value) {
                    setState(() {
                      salaryByAgreement = value ?? false;
                      if (salaryByAgreement) {
                        salaryController.clear();
                      }
                    });
                  },
                ),
              ],
              onSubmit: () {
                if (formKey.currentState!.validate()) {
                  context.read<PostJobBloc>().add(
                    PostJobUpdateSalaryEvent(
                      salary: salaryController.text,
                      salaryByAgreement: salaryByAgreement,
                    ),
                  );
                  Navigator.pop(context, true);
                  summaryBottomSheet(context);
                }
              },
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  // Summary Bottom Sheet
  static Future<bool> summaryBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocBuilder<PostJobBloc, PostJobState>(
          builder: (context, state) {
            if (state is PostJobData) {
              return CustomBottomSheet(
                title: 'Summary',
                fields: const [],
                buttonText: 'Post Job',
                formKey: GlobalKey<FormState>(),
                additionalWidgets: [
                  ListTile(
                    title: const Text('Profession'),
                    subtitle: Text(state.profession ?? 'Not selected'),
                  ),
                  ListTile(
                    title: const Text('Description'),
                    subtitle: Text(state.description ?? 'Not entered'),
                  ),
                  ListTile(
                    title: const Text('Contacts'),
                    subtitle: Text(
                      state.contacts?.join(', ') ?? 'Not selected',
                    ),
                  ),
                  ListTile(
                    title: const Text('Salary'),
                    subtitle: Text(
                      state.salaryByAgreement == true
                          ? 'By agreement'
                          : (state.salary ?? 'Not entered'),
                    ),
                  ),
                ],
                onSubmit: () {
                  context.read<PostJobBloc>().add(const PostJobSubmitEvent());
                  Navigator.pop(context, true);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    ).then((value) => value ?? false);
  }
}
