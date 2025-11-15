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
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';

class EmpProfileEditBasicInfo extends StatefulWidget {
  const EmpProfileEditBasicInfo({super.key});

  @override
  EmpProfileEditBasicInfoState createState() => EmpProfileEditBasicInfoState();
}

class EmpProfileEditBasicInfoState extends State<EmpProfileEditBasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userState = context.read<EmpUserBloc>().state;
    if (userState is EmpUserLoaded) {
      _nameController.text = userState.user.name ?? '';
      _dobController.text = userState.user.birthDate != null
          ? userState.user.birthDate!.toIso8601String().split('T').first
          : '';
      _bioController.text = userState.user.about ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _bioController.dispose();
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
      final userState = context.read<EmpUserBloc>().state;
      if (userState is EmpUserLoaded) {
        final updatedUser = EmpUserProfileEntity(
          userID: userState.user.userID,
          email: userState.user.email,
          name: _nameController.text.trim(),
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
          birthDate: DateTime.tryParse(_dobController.text),
          education: userState.user.education,
          about: _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
          age: userState.user.age,
          workExperience: userState.user.workExperience,
          contacts: userState.user.contacts,
          defaultContact: userState.user.defaultContact,
        );
        context.read<EmpUserBloc>().add(
          EmpUpdateUserProfileEvent(updatedUser: updatedUser),
        );
      }
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
                      child: BlocListener<EmpUserBloc, EmpUserState>(
                        listener: (context, state) {
                          if (state is EmpUserUpdated) {
                            Navigator.of(context).pop();
                          } else if (state is EmpUserError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
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
                                    ),

                                    const SizedBox(height: 16),
                                    CustomInputText(
                                      hintText: 'Расскажите о себе',
                                      labelText: "Био",
                                      controller: _bioController,
                                      minLines: 6,
                                      maxLines: 10,
                                      validator: FormValidations.validateBio,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              BlocBuilder<EmpUserBloc, EmpUserState>(
                                builder: (context, state) {
                                  final isLoading = state is EmpUserUpdating;
                                  return Column(
                                    children: [
                                      CustomButtonEmployee(
                                        btnText: isLoading
                                            ? 'Сохранение...'
                                            : 'Сохранить',
                                        onTap: isLoading ? null : _save,
                                        isLoading: isLoading,
                                      ),
                                      const SizedBox(height: 16),
                                      TextButton(
                                        onPressed: isLoading ? null : _cancel,
                                        child: const Text(
                                          'Отмена',
                                          style: TextStyle(
                                            color: AppPalette.empPrimaryColor,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
