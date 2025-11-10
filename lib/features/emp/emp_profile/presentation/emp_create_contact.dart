import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

class ContactModel {
  String? name;
  String? telegram;
  String? whatsapp;
  String? email;
  String? vk;
  String? phone;

  ContactModel({
    this.name,
    this.telegram,
    this.whatsapp,
    this.email,
    this.vk,
    this.phone,
  });
}

class CreateEditContactPage extends StatefulWidget {
  final ContactEntity? contact; // if null, create new

  const CreateEditContactPage({super.key, this.contact});

  @override
  State<CreateEditContactPage> createState() => _CreateEditContactPageState();
}

class _CreateEditContactPageState extends State<CreateEditContactPage> {
  late TextEditingController _nameController;
  late TextEditingController _telegramController;
  late TextEditingController _whatsappController;
  late TextEditingController _emailController;
  late TextEditingController _vkController;
  late TextEditingController _phoneController;

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
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _vkController = TextEditingController(text: widget.contact?.vk ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _telegramController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _vkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    final newContact = ContactModel(
      name: _nameController.text.trim(),
      telegram: _telegramController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      email: _emailController.text.trim(),
      vk: _vkController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    // Return the created/edited contact to the previous page
    Navigator.pop(context, newContact);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.contact == null ? 'Create Contact' : 'Edit Contact',
        isEmployee: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomInputText(
              labelText: "Name",
              hintText: "Enter contact name",
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            CustomInputText(
              labelText: "Telegram",
              hintText: "@username",
              controller: _telegramController,
            ),
            const SizedBox(height: 16),
            CustomInputText(
              labelText: "WhatsApp",
              hintText: "+123456789",
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomInputText(
              labelText: "Email",
              hintText: "example@email.com",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomInputText(
              labelText: "VK",
              hintText: "vk.com/username",
              controller: _vkController,
            ),
            const SizedBox(height: 16),
            CustomInputText(
              labelText: "Phone",
              hintText: "+1234567890",
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 32),

            CustomButtonEmployee(btnText: "Save Contact", onTap: _saveContact),

            const SizedBox(height: 16),
            _updateButtons(
              text: "Управление подпиской",
              error: true,
              onTap: () {
                Navigator.maybePop(context);
                Navigator.maybePop(context);

                // context.pushNamed(RouteName.welcomePage);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
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
