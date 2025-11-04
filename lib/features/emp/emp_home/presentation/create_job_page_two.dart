import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/job_phase_create.dart';

class CreateJobPageTwo extends StatefulWidget {
  const CreateJobPageTwo({
    super.key,
     this.speciality,
     this.description,
     this.salary,
     this.salaryWithAgreement,
  });

  final String? speciality;
  final String? description;
  final String? salary;
  final bool? salaryWithAgreement;

  @override
  _CreateJobPageTwoState createState() => _CreateJobPageTwoState();
}

class _CreateJobPageTwoState extends State<CreateJobPageTwo> {
  final TextEditingController _contact = TextEditingController();

  final TextEditingController _link = TextEditingController();

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
                child: CustomProgressBar(totalProgress: 2, filledProgress: 1),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          formData(context),
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

  Widget formData(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          GestureDetector(
            onTap: _showMultiSelectDialog, // same callback as before
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _displaySelection,
                      style: TextStyle(
                        color: _selectedOptions.isEmpty
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 14,
                      ),
                      softWrap: true,
                    ),
                  ),
                  const CustomImageView(
                    imagePath: MediaRes.dropDownIcon,
                    width: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          CustomInputText(
            hintText: 'Текст',
            labelText: "Ссылка",
            controller: TextEditingController(),
          ),
          const SizedBox(height: 16),

          CustomButtonEmployee(
            btnText: 'Далее',
            onTap: () {
              context.pushNamed(
                RouteName.createJobPageThree,
                extra: {
                  'salary': widget.salary,
                  'speciality': widget.speciality,
                  "description": widget.description,
                  "salaryWithAgreement": widget.salaryWithAgreement,
                  'contactAddresses': _displaySelection,
                  'links': 'links',
                },
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  final List<String> _contactOptions = ['Telegram', 'WhatsApp', 'VK'];

  Set<String> _selectedOptions = {};

  // 3. Helper to format the display text based on selections
  String get _displaySelection {
    if (_selectedOptions.isEmpty) {
      return 'Выбрать...';
    }
    return _selectedOptions.toList().join(', ');
  }

  // --- SHOW DIALOG FUNCTION ---
  void _showMultiSelectDialog() async {
    // Create a temporary set for selection within the dialog
    Set<String> tempSelected = Set.from(_selectedOptions);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Contact Methods'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _contactOptions.map((option) {
                    return CheckboxListTile(
                      title: Text(option),
                      checkColor: AppPalette.white,
                      selectedTileColor: AppPalette.empPrimaryColor,
                      activeColor: AppPalette.empPrimaryColor,
                      value: tempSelected.contains(option),
                      onChanged: (bool? isChecked) {
                        setDialogState(() {
                          if (isChecked == true) {
                            tempSelected.add(option);
                          } else {
                            tempSelected.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('CANCEL'),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOptions = tempSelected;
                });
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.empPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.empPrimaryColor.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
