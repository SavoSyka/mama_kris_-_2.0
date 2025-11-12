import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/fetch_emp_jobs_cubit.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/fetch_emp_jobs_state.dart';

enum FilterType { active, drafts, archive }

class EmpHomeScreen extends StatefulWidget {
  const EmpHomeScreen({super.key});

  @override
  _EmpHomeScreenState createState() => _EmpHomeScreenState();
}

class _EmpHomeScreenState extends State<EmpHomeScreen> {
  FilterType selectedFilter = FilterType.active;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  void _fetchJobs() {
    final status = _mapFilterToStatus(selectedFilter);
    context.read<FetchEmpJobsCubit>().fetchJobs(status);
  }

  String _mapFilterToStatus(FilterType filter) {
    switch (filter) {
      case FilterType.active:
        return 'active';
      case FilterType.drafts:
        return 'drafted';
      case FilterType.archive:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Вакансии',
        showLeading: false,
        alignTitleToEnd: false,
      ),
      body: BlocBuilder<FetchEmpJobsCubit, FetchEmpJobsState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(color: AppPalette.empBgColor),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: CustomDefaultPadding(
                        child: Column(
                          children: [
                            Container(
                              // color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Updated section with enum values for Активные, Черновики, Архив
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = FilterType.active;
                                          });
                                          _fetchJobs();
                                        },
                                        child: _FilterCard(
                                          isSelected:
                                              selectedFilter ==
                                              FilterType.active,
                                          text: 'Активные',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = FilterType.drafts;
                                          });
                                          _fetchJobs();
                                        },
                                        child: _FilterCard(
                                          isSelected:
                                              selectedFilter ==
                                              FilterType.drafts,
                                          text: 'Черновики',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = FilterType.archive;
                                          });
                                          _fetchJobs();
                                        },
                                        child: _FilterCard(
                                          isSelected:
                                              selectedFilter ==
                                              FilterType.archive,
                                          text: 'Архив',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            if (state is FetchEmpJobsLoaded &&
                                state.jobList.jobs.isEmpty)
                              const _CreateJobCard()
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final job = state is FetchEmpJobsLoaded
                                      ? state.jobList.jobs[index]
                                      : null;
                                  if (job == null) return Container();
                                  return _JobCard(
                                    jobTitle: job.title,
                                    salaryRange: job.salary,
                                    onTap: () {
                                      // TODO: Navigate to job detail
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8),
                                itemCount: state is FetchEmpJobsLoaded
                                    ? state.jobList.jobs.length
                                    : 0,
                              ),

                            if (state is FetchEmpJobsLoading)
                              const Center(child: CircularProgressIndicator()),

                            if (state is FetchEmpJobsError)
                              Center(child: Text('Error: ${state.message}')),

                            const SizedBox(height: 16),
                            const _AdCards(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isSelected
            ? Border.all(color: AppPalette.empPrimaryColor)
            : null,
      ),
      child: CustomText(text: text),
    );
  }
}

class _AdCards extends StatelessWidget {
  const _AdCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          const CustomText(
            text: 'Хотите создать еще вакансию?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              context.pushNamed(RouteName.createJobPageOne);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration,
              child: const CustomText(
                text: 'Создать',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF596574),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.jobTitle,
    required this.salaryRange,
    required this.onTap,
  });

  final String jobTitle;
  final String salaryRange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Salary: $salaryRange',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateJobCard extends StatelessWidget {
  const _CreateJobCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text(
            'Вакансий еще нет',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppPalette.empPrimaryColor,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 175,
            child: Text(
              'Но вы можете рассказать о своей задаче нашим мамам',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF596574),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.30,
              ),
            ),
          ),
          const SizedBox(height: 24),

          CustomButtonSec(
            btnText: '',
            onTap: () {
              context.pushNamed(RouteName.createJobPageOne);
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
        ],
      ),
    );
  }
}
