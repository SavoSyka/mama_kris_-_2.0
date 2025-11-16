import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
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
  const ApplProfileEditWorkExperience({super.key, this.experience});
  final ApplWorkExperienceEntity? experience;

  @override
  State<ApplProfileEditWorkExperience> createState() =>
      ApplProfileEditWorkExperienceState();
}

class ApplProfileEditWorkExperienceState
    extends State<ApplProfileEditWorkExperience> {
  final List<WorkExperienceFormData> _experiences = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    /// If editing single experience → load ONLY that one.
    if (widget.experience != null) {
      _experiences.add(WorkExperienceFormData.fromEntity(widget.experience!));
      return;
    }

    /// If creating new → load list from user OR add empty
    final state = context.read<UserBloc>().state;
    if (state is UserLoaded && state.user.workExperience != null) {
      _experiences.addAll(
        state.user.workExperience!.map(
          (exp) => WorkExperienceFormData.fromEntity(exp),
        ),
      );
    }

    /// Ensure at least 1 item
    if (_experiences.isEmpty) _addExperience();
  }

  void _addExperience() {
    setState(() => _experiences.add(WorkExperienceFormData()));
  }

  void _removeExperience(int index) {
    setState(() => _experiences.removeAt(index));
  }

  bool _validateAll() {
    if (!_formKey.currentState!.validate()) return false;

    for (final exp in _experiences) {
      if (!exp.isValid()) return false;
    }
    return true;
  }

  void _save() {
    if (!_validateAll()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, исправьте ошибки в форме.')),
      );
      return;
    }

    final userState = context.read<UserBloc>().state;
    if (userState is! UserLoaded) return;

    final updatedUser = userState.user.copyWith(
      workExperience: _experiences.map((e) => e.toEntity()).toList(),
    );

    context.read<UserBloc>().add(
      UpdateUserProfileEvent(updatedUser: updatedUser),
    );
  }

  void _cancel() => Navigator.pop(context);

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
                  child: CustomDefaultPadding(
                    bottom: 0,
                    child: BlocListener<UserBloc, UserState>(
                      listener: (context, state) {
                        if (state is UserUpdated) {
                          Navigator.pop(context);
                        } else if (state is UserError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      child: Form(
                        key: _formKey,

                        child: Column(
                          children: [
                            ..._experiences.asMap().entries.map((entry) {
                              final index = entry.key;
                              final form = entry.value;

                              return _WorkExperienceForm(
                                key: ValueKey(index),
                                data: form,
                                onRemove: widget.experience == null && index > 0
                                    ? () => _removeExperience(index)
                                    : null,
                              );
                            }),

                            /// Add button only when creating (not editing)
                            if (widget.experience == null) ...[
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
                            ],

                            const SizedBox(height: 32),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                final loading = state is UserUpdating;
                                return Column(
                                  children: [
                                    CustomButtonApplicant(
                                      btnText: loading
                                          ? 'Сохранение...'
                                          : 'Сохранить',
                                      onTap: loading ? null : _save,
                                      isLoading: loading,
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: loading ? null : _cancel,
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
      position: _text(positionController),
      company: _text(companyController),
      location: _text(locationController),
      startDate: _text(startDateController),
      endDate: isPresent ? null : _text(endDateController),
      description: _text(descriptionController),
      isPresent: isPresent,
    );
  }

  bool isValid() {
    return FormValidations.validatePosition(positionController.text) == null &&
        FormValidations.validateCompany(companyController.text) == null &&
        FormValidations.validateWorkStartDate(startDateController.text) ==
            null &&
        FormValidations.validateWorkEndDate(
              endDateController.text,
              startDateController.text,
              isPresent,
            ) ==
            null &&
        FormValidations.validateWorkDescription(descriptionController.text) ==
            null;
  }

  String? _text(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

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
  const _WorkExperienceForm({super.key, required this.data, this.onRemove});

  final WorkExperienceFormData data;
  final VoidCallback? onRemove;

  @override
  State<_WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<_WorkExperienceForm> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header + remove button
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
            controller: data.positionController,
            validator: FormValidations.validatePosition,
          ),
          const SizedBox(height: 12),

          CustomInputText(
            hintText: 'Компания',
            labelText: 'Компания',
            controller: data.companyController,
            validator: FormValidations.validateCompany,
          ),
          const SizedBox(height: 12),

          CustomInputText(
            hintText: 'Местоположение',
            labelText: 'Местоположение (опционально)',
            controller: data.locationController,
          ),
          const SizedBox(height: 12),

          CustomDateInput(
            controller: data.startDateController,
            label: 'Дата начала',
            validator: FormValidations.validateWorkStartDate,
          ),
          const SizedBox(height: 12),

          if (!data.isPresent)
            CustomDateInput(
              controller: data.endDateController,
              label: 'Дата окончания',
              validator: (value) => FormValidations.validateWorkEndDate(
                value,
                data.startDateController.text,
                data.isPresent,
              ),
            ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Text('По настоящее время'),
              Checkbox(
                value: data.isPresent,
                onChanged: (value) {
                  setState(() {
                    data.isPresent = value ?? false;
                    if (value == true) data.endDateController.clear();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          CustomInputText(
            hintText: 'Описание обязанностей',
            labelText: 'Описание (опционально)',
            controller: data.descriptionController,
            minLines: 3,
            maxLines: 5,
            validator: FormValidations.validateWorkDescription,
          ),
        ],
      ),
    );
  }
}
