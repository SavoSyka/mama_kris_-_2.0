import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_static_input.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class ApplCreateContactScreen extends StatefulWidget {
  final ApplContactEntity? contact; // if null, create new

  const ApplCreateContactScreen({super.key, this.contact});

  @override
  State<ApplCreateContactScreen> createState() =>
      _ApplCreateContactScreenState();
}

class _ApplCreateContactScreenState extends State<ApplCreateContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _telegramController;
  late TextEditingController _whatsappController;
  late TextEditingController _vkController;
  late TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _telegramController = TextEditingController(
      text: widget.contact?.telegram ?? '',
    );
    _whatsappController = TextEditingController(
      text: widget.contact?.whatsapp ?? '',
    );
    _vkController = TextEditingController(text: widget.contact?.vk ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    getEmail();
  }

  String _email = '';
  void getEmail() {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      setState(() {
        _email = userState.user.email ?? "";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _telegramController.dispose();
    _whatsappController.dispose();
    _vkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (!_formKey.currentState!.validate()) return;
    final localContact = ApplicantContact(
      contactId: 0, // MOCKID i donn use it in my ocee
      name: _nameController.text.trim(),
      telegram: _telegramController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      email: _email,
      vk: _vkController.text.trim(),
      phone: _phoneController.text.trim(),
      userId: 0, // MOCKID i donn use it in my ocee
    );

    // Return the created/edited contact to the previous page
    // Navigator.pop(context, newContact);

    if (widget.contact == null) {
      context.read<ApplicantContactBloc>().add(
        CreateApplicantContactEvent(contact: localContact),
      );
    } else {
      context.read<ApplicantContactBloc>().add(
        UpdateApplicantContactEvent(
          contact: localContact,
          id: widget.contact?.contactsID.toString() ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: widget.contact == null
            ? 'Создать контакт'
            : 'Редактирование контакта',
        isEmployee: true,
      ),
      body: BlocConsumer<ApplicantContactBloc, ApplicantContactState>(
        listener: (context, state) {
          debugPrint("state after deleted $state");
          if (state is ApplicantContactCreated) {
            final cont = ApplContactEntity(
              name: state.contact.name,
              contactsID: state.contact.contactId,
              email: state.contact.email,
              telegram: state.contact.telegram,
              userID: state.contact.userId,
              phone: state.contact.phone,
              vk: state.contact.vk,
              whatsapp: state.contact.whatsapp,
            );
            updateCreatedContact(cont);
          } else if (state is ApplicantContactUpdated) {
            final cont = ApplContactEntity(
              name: state.contact.name,
              contactsID: state.contact.contactId,
              email: state.contact.email,
              telegram: state.contact.telegram,
              userID: state.contact.userId,
              phone: state.contact.phone,
              vk: state.contact.vk,
              whatsapp: state.contact.whatsapp,
            );
            updateEditedContact(cont);
          } else if (state is ApplicantContactDeleted) {
            debugPrint("Contact deleted in ui");
            updateDeletedContact();
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                context.pop(true);
              }
              // TODO: implement listener
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),

              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: [
                          CustomInputText(
                            labelText: "Имя",
                            hintText: "Введите имя контакта",
                            controller: _nameController,
                            validator: FormValidations.validateName,
                          ),
                          const SizedBox(height: 16),
                          CustomInputText(
                            labelText: "Telegram",
                            hintText: "@username",
                            controller: _telegramController,
                            validator: (value) =>
                                FormValidations.contactTelegram(value),
                          ),
                          const SizedBox(height: 16),
                          CustomInputText(
                            labelText: "WhatsApp",
                            hintText: "+123456789",
                            controller: _whatsappController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                FormValidations.contactWhatsApp(value),
                          ),
                          const SizedBox(height: 16),
                          CustomStaticInput(
                            label: 'Почта',
                            value: _email ,
                            hasGreyBg: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputText(
                            labelText: "VK",
                            hintText: "vk.com/username",
                            controller: _vkController,
                            validator: (value) =>
                                FormValidations.contactVk(value),
                          ),
                          const SizedBox(height: 16),
                          CustomInputText(
                            labelText: "Телефон",
                            hintText: "+1234567890",
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                FormValidations.validatePhone(value),
                          ),

                          const SizedBox(height: 32),

                          CustomButtonApplicant(
                            btnText: "Сохранить контакт",

                            onTap: _saveContact,
                            isLoading: state is ApplicantContactLoading,
                            isBtnActive: state is! ApplicantContactLoading,
                          ),

                          if (widget.contact != null) ...[
                            const SizedBox(height: 16),
                            _updateButtons(
                              text: "Управление подпиской",
                              error: true,
                              onTap: () {
                                debugPrint(
                                  "Contact Deleted ${widget.contact!.contactsID!}",
                                );

                                context.read<ApplicantContactBloc>().add(
                                  DeleteApplicantContactEvent(
                                    id:
                                        widget.contact?.contactsID.toString() ??
                                        '',
                                  ),
                                );

                                // context.pushNamed(RouteName.welcomePage);
                              },
                            ),
                          ],

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // * ────────────── update contacts after create ───────────────────────

  void updateCreatedContact(ApplContactEntity conta) {
    context.read<UserBloc>().add(AddContactEvent(conta));
  }
  // * ────────────── update contacts after edit ───────────────────────

  void updateEditedContact(ApplContactEntity conta) {
    context.read<UserBloc>().add(EditContactEvent(conta));
  }

  // * ────────────── update contacts after delete ───────────────────────
  void updateDeletedContact() {
    debugPrint("Contact Deleted ${widget.contact!.contactsID!}");
    context.read<UserBloc>().add(
      DeleteContactEvent(widget.contact!.contactsID!),
    );
  }
}

class _updateButtons extends StatelessWidget {
  const _updateButtons({
    this.text = 'Добавить контакт',
    this.error = false,
    this.errorIcon,

    this.onTap,
  });
  final String text;
  final bool error;
  final String? errorIcon;

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: error
                ? const BorderSide(color: AppPalette.error)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x332E7866),
              blurRadius: 4,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [
            Text(
              text,
              style: TextStyle(
                color: error ? AppPalette.error : AppPalette.empPrimaryColor,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),

            if (error)
              CustomImageView(
                imagePath: errorIcon ?? MediaRes.deleteIcon,
                width: 24,
              ),
          ],
        ),
      ),
    );
  }
}
