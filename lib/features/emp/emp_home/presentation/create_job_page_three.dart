import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/job_phase_create.dart';

class CreateJobPageThree extends StatefulWidget {
  const CreateJobPageThree({
    super.key,
    this.speciality,
    this.description,
    this.salary,
    this.salaryWithAgreement,
    this.contactAddress,
    this.link,
  });

  final String? speciality;
  final String? description;
  final String? salary;
  final bool? salaryWithAgreement;
  final ContactEntity? contactAddress;
  final String? link;

  @override
  _CreateJobPageThreeState createState() => _CreateJobPageThreeState();
}

class _CreateJobPageThreeState extends State<CreateJobPageThree> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Создание вакансии', showLeading: true),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppPalette.empBgColor),

        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CustomProgressBar(totalProgress: 2, filledProgress: 2),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          _formPreview(context),
                        ],
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

  Widget _formPreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            widget.speciality ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),

          if (!(widget.salaryWithAgreement ?? false)) ...[
            const SizedBox(height: 12),

            Text(
              widget.salary ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
          ],
          const SizedBox(height: 16),

          SizedBox(
            child: Text(
              widget.description ?? '',
              style: const TextStyle(
                color: Color(0xFF596574),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 311,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contact information through",
                  style: TextStyle(
                    color: Color(0xFF596574),
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
                contactPreview(widget.contactAddress),
              ],
            ),
          ),

          const SizedBox(height: 24),

          CustomButtonEmployee(
            btnText: 'Далее',
            onTap: () {
              context.pushNamed(RouteName.homeEmploye);
            },
          ),

          const SizedBox(height: 24),

          CustomButtonSec(
            btnText: '',
            onTap: () {
              context.pushNamed(RouteName.homeEmploye);
            },
            child: const Text(
              'Рассказать',
              style: TextStyle(
                color: Color(0xFF0073BB),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const SizedBox(
            width: 311,
            child: Text(
              'Чтобы опубликовать вакансию необходима подписка',
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 10,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _basicInformation extends StatelessWidget {
  const _basicInformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const SizedBox(
            width: 311,
            child: Text(
              'Оператор Call-Центра',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            'от 6000 руб',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(
            width: 311,
            child: Text(
              'Принимаем входящие звонки и консультируем клиентов по готовому скрипту. Ваша задача — помогать, отвечать на вопросы и передавать заказы менеджерам. Подходит для работы из дома в удобное время.',
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
          ),
          const SizedBox(height: 16),

          const CustomButtonEmployee(btnText: 'Далее'),

          const SizedBox(height: 24),

          CustomButtonSec(
            btnText: '',
            onTap: () {
              // context.pushNamed(Ro uteName.createJobPageOne);
            },
            child: const Text(
              'Рассказать',
              style: TextStyle(
                color: Color(0xFF0073BB),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const SizedBox(
            width: 311,
            child: Text(
              'Чтобы опубликовать вакансию необходима подписка',
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 10,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Contacts extends StatelessWidget {
  const _Contacts();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Контакты',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'Telegram',
            labelText: "Как с вами связаться?",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: '******',
            labelText: "Ссылка",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: 'VK',
            labelText: "Как с вами связаться?",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 8),

          CustomInputText(
            hintText: '*****',
            labelText: "Ссылка",
            controller: TextEditingController(),
          ),
          CustomInputText(
            hintText: '+79997773322',
            labelText: "Номер телефона",
            controller: TextEditingController(),
          ),

          const SizedBox(height: 16),
          const _updateButtons(),
        ],
      ),
    );
  }
}

class _accounts extends StatefulWidget {
  const _accounts();

  @override
  State<_accounts> createState() => _AccountsState();
}

class _AccountsState extends State<_accounts> {
  bool _acceptOrders =
      false; // Default to false, can be loaded from preferences or API

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Аккаунт',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Принимать заказы',
                style: TextStyle(
                  color: Color(0xFF596574),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                ),
              ),
              const Spacer(),
              Switch(
                value: _acceptOrders,
                onChanged: (bool value) {
                  setState(() {
                    _acceptOrders = value;
                  });
                  // TODO: Save the preference to backend or local storage
                },
                activeThumbColor: AppPalette.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _updateButtons(text: "Управление подпиской"),
          const SizedBox(height: 16),
          const _updateButtons(text: "Управление подпиской", error: true),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _updateButtons extends StatelessWidget {
  const _updateButtons({this.text = 'Добавить контакт', this.error = false});
  final String text;
  final bool error;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: error ? AppPalette.error : const Color(0xFF2E7866),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),

          if (error)
            const CustomImageView(imagePath: MediaRes.deleteIcon, width: 24),
        ],
      ),
    );
  }
}

Widget contactPreview(ContactEntity? contact) {
  if (contact == null) {
    return const Text(
      "No contact selected",
      style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Manrope'),
    );
  }

  // Collect available contact fields dynamically
  final contactDetails = <Map<String, String>>[];
  if (contact.telegram != null && contact.telegram!.isNotEmpty) {
    contactDetails.add({'label': 'Telegram', 'value': contact.telegram!});
  }
  if (contact.whatsapp != null && contact.whatsapp!.isNotEmpty) {
    contactDetails.add({'label': 'WhatsApp', 'value': contact.whatsapp!});
  }
  if (contact.email != null && contact.email!.isNotEmpty) {
    contactDetails.add({'label': 'Email', 'value': contact.email!});
  }
  if (contact.vk != null && contact.vk!.isNotEmpty) {
    contactDetails.add({'label': 'VK', 'value': contact.vk!});
  }
  if (contact.phone != null && contact.phone!.isNotEmpty) {
    contactDetails.add({'label': 'Phone', 'value': contact.phone!});
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9FB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE3E8EF)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact header
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              color: Color(0xFF2F80ED),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              contact.name ?? "Unnamed Contact",
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List contact channels (Telegram, Email, etc.)
        ...contactDetails.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  "${item['label']}: ",
                  style: const TextStyle(
                    color: Color(0xFF596574),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Manrope',
                  ),
                ),
                Flexible(
                  child: Text(
                    item['value']!,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
