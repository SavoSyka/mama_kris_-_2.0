import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/form_validations.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_entity.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/job_phase_create.dart';

class CreateJobPageOne extends StatefulWidget {
  const CreateJobPageOne({super.key, this.job});

  final EmpJobEntity? job;

  @override
  _CreateJobPageOneState createState() => _CreateJobPageOneState();
}

class _CreateJobPageOneState extends State<CreateJobPageOne> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _speciality;
  late final TextEditingController _description;
  late final TextEditingController _salary;
  late bool _salaryWithAgreement;

  @override
  void initState() {
    super.initState();
    _speciality = TextEditingController(text: widget.job?.title ?? '');
    _description = TextEditingController(text: widget.job?.description ?? '');
    _salary = TextEditingController(
      text: widget.job?.salary == '0' ? '' : widget.job?.salary ?? '',
    );
    _salaryWithAgreement =
        widget.job?.salary == '0' || widget.job?.salary == null;
  }

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
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CustomProgressBar(totalProgress: 2, filledProgress: 0),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: CustomDefaultPadding(
                      bottom: 0,
                      child: Column(
                        children: [
                          // Основная информация -- basic information
                          _formData(context),
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

  Widget _formData(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              '',
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
              hintText: 'Выбрать',
              labelText: "Кого ищете?",
              controller: _speciality,
              validator: FormValidations.validateJobTitle,
            ),
            const SizedBox(height: 8),

            CustomInputText(
              hintText: 'Описание вакансии',
              labelText: "Расскажите о вакансии",
              controller: _description,
              minLines: 8,
              maxLines: 12,
              validator: FormValidations.validateJobDescription,
            ),
            const SizedBox(height: 16),

            if (!_salaryWithAgreement)
              CustomInputText(
                hintText: '10000',
                labelText: "Оплата",
                controller: _salary,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    FormValidations.validateSalary(value, _salaryWithAgreement),
              ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _salaryWithAgreement = !_salaryWithAgreement;
                    });
                  },
                  child: Image.asset(
                    _salaryWithAgreement
                        ? MediaRes.empMarkedBox
                        : MediaRes.empUnmarkedBox,
                    width: 28,
                  ),
                ),
                const SizedBox(width: 8),

                const Expanded(
                  child: CustomText(text: "Оплата по договоренности"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomButtonEmployee(
              btnText: 'Далее',
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final jobEntity = EmpJobEntity(
                    jobId: widget.job?.jobId ?? 0,
                    userId: widget.job?.userId ?? 0,
                    contactsId: widget.job?.contactsId ?? 0,
                    title: _speciality.text,
                    dateTime: widget.job?.dateTime ?? "",
                    description: _description.text,
                    salary: _salary.text,
                    status: widget.job?.status ?? '',
                    contactJobs: widget.job?.contactJobs,
                    salaryWithAgreement: _salaryWithAgreement
                  );
                  context.pushNamed(
                    RouteName.createJobPageTwo,
                    extra: {'job': jobEntity},
                  );
                }
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
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
