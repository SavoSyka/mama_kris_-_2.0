import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_employee.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/emp_user_contact.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/job_phase_create.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';

class CreateJobPageTwo extends StatefulWidget {
  const CreateJobPageTwo({
    super.key,
    this.speciality,
    this.description,
    this.salary,
    this.salaryWithAgreement,
    this.job,
  });

  final String? speciality;
  final String? description;
  final String? salary;
  final bool? salaryWithAgreement;
  final EmpJobEntity? job;

  @override
  _CreateJobPageTwoState createState() => _CreateJobPageTwoState();
}

class _CreateJobPageTwoState extends State<CreateJobPageTwo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _link;
  late ContactJobs? selectedContact;

  @override
  void initState() {
    super.initState();
    _link = TextEditingController(text: widget.job?.contactJobs?.link ?? '');
    selectedContact = widget.job?.contactJobs;

    debugPrint("Contact jobs  ${widget.job?.title} ");
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
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            GestureDetector(
              onTap: () async {
                final cont = await _openContactSheet(context);
                setState(() {
                  selectedContact = cont != null
                      ? ContactJobs(
                          contactsID: cont.contactsID,
                          name: cont.name,
                          telegram: cont.telegram,
                          email: cont.email,
                          phone: cont.phone,
                          whatsapp: cont.whatsapp,
                          vk: cont.vk,
                          link: cont.link,
                        )
                      : null;
                });
              }, // same callback as before
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedContact != null
                            ? selectedContact?.name ?? ""
                            : 'select contact',
                        style: TextStyle(
                          color: "_selectedOptions".isEmpty
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

            CustomButtonEmployee(
              btnText: 'Далее',
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (selectedContact == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Пожалуйста, выберите контакт.'),
                      ),
                    );
                    return;
                  }

                  final jobEntity = widget.job!.copyWith(
                    contactJobs: selectedContact,
                    links: _link.text,
                  );

                  context.pushNamed(
                    RouteName.createJobPageThree,
                    extra: {'job': jobEntity},
                  );

                  // context.pushNamed(
                  //   RouteName.createJobPageThree,
                  //   extra: {
                  //     'salary': widget.salary,
                  //     'speciality': widget.speciality,
                  //     "description": widget.description,
                  //     "salaryWithAgreement": widget.salaryWithAgreement,
                  //     'contactAddress': selectedContact,
                  //     'links': _link.text,
                  //     'jobId': widget.job?.jobId,
                  //   },
                  // );
                }
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<ContactEntity?> _openContactSheet(BuildContext context) async {
    final userState = context.read<EmpUserBloc>().state;

    List<ContactEntity> contacts = [];

    if (userState is EmpUserLoaded) {
      contacts = userState.user.contacts ?? [];
    }

    // Wait for the bottom sheet to return selected contact (or newly created)
    final selectedContact = await showSelectContactSheet(
      context,
      contacts: contacts,
    );

    return selectedContact;
  }
}
