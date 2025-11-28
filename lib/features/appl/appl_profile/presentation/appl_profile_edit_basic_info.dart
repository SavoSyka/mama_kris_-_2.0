import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class ApplProfileEditBasicInfo extends StatefulWidget {
  const ApplProfileEditBasicInfo({super.key});

  @override
  ApplProfileEditBasicInfoState createState() =>
      ApplProfileEditBasicInfoState();
}

class ApplProfileEditBasicInfoState extends State<ApplProfileEditBasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _nameController.text = userState.user.name ?? '';

      final rawDob = userState.user.birthDate;
      _dobController.text = rawDob ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ApplicantContactBloc>().add(
        UpdatingBasicInfoEvent(
          name: _nameController.text,
          dob: _dobController.text,
        ),
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

      appBar: const CustomAppBar(
        title: 'Редактирование основной информации',
        alignTitleToEnd: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),

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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: AppTheme.cardDecoration,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Основная информация',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.30,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  CustomInputText(
                                    hintText: 'Введите полное имя',
                                    labelText: "Полное имя",
                                    controller: _nameController,
                                    validator: FormValidations.validateName,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomDateInput(
                                    controller: _dobController,
                                    label: 'Дата рождения',
                                    isApplicant: true,
                                  ),
                                ],
                              ),
                            ),
                            BlocListener<UserBloc, UserState>(
                              listener: (context, state) {
                                if (state is UserLoaded) {
                                  context.pop(true);
                                }
                                // TODO: implement listener
                              },
                              child: const SizedBox(height: 32),
                            ),

                            BlocConsumer<
                              ApplicantContactBloc,
                              ApplicantContactState
                            >(
                              listener: (context, state) {
                                if (state is UserBasicInfoUpdated) {
                                  context.read<UserBloc>().add(
                                    UpdateBasicInfo(
                                      dob: _dobController.text,
                                      name: _nameController.text,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                final isLoading =
                                    state is ApplicantContactLoading;
                                return Column(
                                  children: [
                                    CustomButtonApplicant(
                                      btnText: isLoading
                                          ? 'Редактировать...'
                                          : 'Редактировать',
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
