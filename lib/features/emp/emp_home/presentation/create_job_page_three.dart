import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/create_job_params.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/create_job_cubit.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/create_job_state.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_entity.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/widget/job_phase_create.dart';

class CreateJobPageThree extends StatefulWidget {
  const CreateJobPageThree({super.key, this.job});

  final EmpJobEntity? job;

  @override
  _CreateJobPageThreeState createState() => _CreateJobPageThreeState();
}

class _CreateJobPageThreeState extends State<CreateJobPageThree> {
  // late Map<String, dynamic> extra;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // extra = GoRouterState.of(context).extra as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateJobCubit, CreateJobState>(
      listener: (context, state) {
        if (state is CreateJobSuccess) {
          context.pushNamed(RouteName.homeEmploye);
        } else if (state is CreateJobError) {
          // Show error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(
            title: 'Создание вакансии',
            showLeading: true,
          ),

          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppPalette.empBgColor),

            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CustomProgressBar(
                      totalProgress: 2,
                      filledProgress: 2,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: CustomDefaultPadding(
                          bottom: 0,
                          child: Column(
                            children: [
                              // Основная информация -- basic information
                              _formPreview(context, state),
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
      },
    );
  }

  Widget _formPreview(BuildContext context, CreateJobState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            widget.job?.title ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),

          if (widget.job?.salaryWithAgreement ?? false) ...[
            const SizedBox(height: 12),

            Text(
              widget.job?.salary ?? '',

              // extra['salary'] ?? "",
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
              widget.job?.description ?? '',

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
                contactPreview(widget.job!.contactJobs),
              ],
            ),
          ),

          const SizedBox(height: 24),

          CustomButtonEmployee(
            btnText: "Опубликовать",
            onTap: state is CreateJobLoading
                ? null
                : () {
                    final params = CreateJobParams(
                      title: widget.job!.title,
                      description: widget.job!.description,
                      salary: widget.job!.salary,
                      salaryWithAgreement:
                          widget.job!.salaryWithAgreement ?? false,
                      contactsID: widget.job!.contactJobs!.contactsID!,

                      link: widget.job!.links ?? "",
                      jobId: widget.job!.jobId,
                    );
                    context.read<CreateJobCubit>().createOrUpdateJob(params);
                  },
          ),

          // const SizedBox(height: 24),

          // CustomButtonSec(
          //   btnText: '',
          //   onTap: () {
          //     context.pushNamed(RouteName.homeEmploye);
          //   },
          //   child: const Text(
          //     'Оставить в черновике',
          //     style: TextStyle(
          //       color: Color(0xFF0073BB),
          //       fontSize: 16,
          //       fontFamily: 'Manrope',
          //       fontWeight: FontWeight.w600,
          //       height: 1.30,
          //     ),
          //   ),
          // ),

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

Widget contactPreview(ContactJobs? contact) {
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
