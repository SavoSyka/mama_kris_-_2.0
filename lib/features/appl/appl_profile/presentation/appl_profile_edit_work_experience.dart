import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_date_input.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';

class ApplProfileEditWorkExperience extends StatefulWidget {
  const ApplProfileEditWorkExperience({super.key});

  @override
  ApplProfileEditWorkExperienceState createState() => ApplProfileEditWorkExperienceState();
}

class ApplProfileEditWorkExperienceState extends State<ApplProfileEditWorkExperience> {
  final List<WorkExperienceFormData> _experiences = [];

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded && userState.user.workExperience != null) {
      _experiences.addAll(
        userState.user.workExperience!.map((exp) => WorkExperienceFormData.fromEntity(exp)),
      );
    }
    if (_experiences.isEmpty) {
      _addExperience();
    }
  }

  void _addExperience() {
    setState(() {
      _experiences.add(WorkExperienceFormData());
    });
  }

  void _removeExperience(int index) {
    setState(() {
      _experiences.removeAt(index);
    });
  }

  bool _validateAll() {
    for (final exp in _experiences) {
      if (!exp.isValid()) {
        return false;
      }
    }
    return true;
  }

  void _save() {
    if (_validateAll()) {
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded) {
        final updatedUser = UserProfileEntity(
          userID: userState.user.userID,
          email: userState.user.email,
          name: userState.user.name,
          phone: userState.user.phone,
          dateTime: userState.user.dateTime,
          signedIn: userState.user.signedIn,
          choice: userState.user.choice,
          appleID: userState.user.appleID,
          role: userState.user.role,
          provider: userState.user.provider,
          defaultContactId: userState.user.defaultContactId,
          specializations: userState.user.specializations,
          specializationsNorm: userState.user.specializationsNorm,
          birthDate: userState.user.birthDate,
          education: userState.user.education,
          about: userState.user.about,
          workExperience: _experiences.map((e) => e.toEntity()).toList(),
          age: userState.user.age,
        );
        context.read<UserBloc>().add(UpdateUserProfileEvent(updatedUser: updatedUser));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, исправьте ошибки в форме.')),
      );
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Редактирование опыта работы'),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppPalette.empBgColor),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: BlocListener<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserUpdated) {
                            Navigator.of(context).pop();
                          } else if (state is UserError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            ..._experiences.asMap().entries.map((entry) {
                              final index = entry.key;
                              final exp = entry.value;
                              return _WorkExperienceForm(
                                key: ValueKey(index),
                                data: exp,
                                onRemove: index > 0 ? () => _removeExperience(index) : null,
                              );
                            }),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _addExperience,
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить опыт работы'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPalette.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                final isLoading = state is UserUpdating;
                                return Column(
                                  children: [
                                    CustomButtonEmployee(
                                      btnText: isLoading ? 'Сохранение...' : 'Сохранить',
                                      onTap: isLoading ? null : _save,
                                      isLoading: isLoading,
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: isLoading ? null : _cancel,
                                      child: const Text(
                                        'Отмена',
                                        style: TextStyle(
                                          color: AppPalette.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkExperienceFormData {
  final TextEditingController positionController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isPresent = false;

  WorkExperienceFormData();

  factory WorkExperienceFormData.fromEntity(ApplWorkExperienceEntity entity) {
    final data = WorkExperienceFormData();
    data.positionController.text = entity.position ?? '';
    data.companyController.text = entity.company ?? '';
    data.locationController.text = entity.location ?? '';
    data.startDateController.text = entity.startDate ?? '';
    data.endDateController.text = entity.endDate ?? '';
    data.descriptionController.text = entity.description ?? '';
    data.isPresent = entity.isPresent;
    return data;
  }

  ApplWorkExperienceEntity toEntity() {
    return ApplWorkExperienceEntity(
      position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
      company: companyController.text.trim().isEmpty ? null : companyController.text.trim(),
      location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
      startDate: startDateController.text.trim().isEmpty ? null : startDateController.text.trim(),
      endDate: isPresent ? null : (endDateController.text.trim().isEmpty ? null : endDateController.text.trim()),
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      isPresent: isPresent,
    );
  }

  bool isValid() {
    return FormValidations.validatePosition(positionController.text) == null &&
           FormValidations.validateCompany(companyController.text) == null &&
           FormValidations.validateWorkStartDate(startDateController.text) == null &&
           FormValidations.validateWorkEndDate(endDateController.text, startDateController.text, isPresent) == null &&
           FormValidations.validateWorkDescription(descriptionController.text) == null;
  }

  void dispose() {
    positionController.dispose();
    companyController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
  }
}

class _WorkExperienceForm extends StatefulWidget {
  final WorkExperienceFormData data;
  final VoidCallback? onRemove;

  const _WorkExperienceForm({super.key, required this.data, this.onRemove});

  @override
  _WorkExperienceFormState createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<_WorkExperienceForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Опыт работы',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete, color: AppPalette.error),
                ),
            ],
          ),
          const SizedBox(height: 16),
          CustomInputText(
            hintText: 'Должность',
            labelText: 'Должность',
            controller: widget.data.positionController,
            validator: FormValidations.validatePosition,
          ),
          const SizedBox(height: 12),
          CustomInputText(
            hintText: 'Компания',
            labelText: 'Компания',
            controller: widget.data.companyController,
            validator: FormValidations.validateCompany,
          ),
          const SizedBox(height: 12),
          CustomInputText(
            hintText: 'Местоположение',
            labelText: 'Местоположение (опционально)',
            controller: widget.data.locationController,
          ),
          const SizedBox(height: 12),
          CustomDateInput(
            controller: widget.data.startDateController,
            label: 'Дата начала',
            validator: FormValidations.validateWorkStartDate,
          ),
          const SizedBox(height: 12),
             if(!widget.data.isPresent)
             CustomDateInput(
               controller: widget.data.endDateController,
               label: 'Дата окончания',
               validator: (value) => FormValidations.validateWorkEndDate(
                 value,
                 widget.data.startDateController.text,
                 widget.data.isPresent,
               ),
             ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('По настоящее время'),
              Checkbox(
                value: widget.data.isPresent,
                onChanged: (value) {
                  setState(() {
                    widget.data.isPresent = value ?? false;
                    if (widget.data.isPresent) {
                      widget.data.endDateController.clear();
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomInputText(
            hintText: 'Описание обязанностей',
            labelText: 'Описание (опционально)',
            controller: widget.data.descriptionController,
            minLines: 3,
            maxLines: 5,
            validator: FormValidations.validateWorkDescription,
          ),
        ],
      ),
    );
  }
}