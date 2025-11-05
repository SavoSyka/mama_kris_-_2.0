import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/job_list_item.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_state.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_filter.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_slider.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/search_bottomsheet.dart';

class ApplHomeScreen extends StatefulWidget {
  const ApplHomeScreen({super.key});

  @override
  _ApplHomeScreenState createState() => _ApplHomeScreenState();
}

class _ApplHomeScreenState extends State<ApplHomeScreen> {
  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1;
  bool isSlider = true;

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(FetchJobsEvent());
  }

  void _handleVacancyReaction({required bool isLiked}) {
    final state = context.read<JobBloc>().state;
    if (state is! JobLoaded || state.jobs.jobs.isEmpty) return;

    final currentJob = state.jobs.jobs[currentVacancyIndex];
    if (isLiked) {
      context.read<JobBloc>().add(LikeJobEvent(currentJob.jobId));
    } else {
      context.read<JobBloc>().add(DislikeJobEvent(currentJob.jobId));
    }

    setState(() {
      previousVacancyIndex = currentVacancyIndex;
      slideDirection = isLiked ? -1 : 1;
      currentVacancyIndex = (currentVacancyIndex + 1) % state.jobs.jobs.length;
    });
  }

  void _onSearchChanged(String query) {
    context.read<JobBloc>().add(SearchJobsEvent(query));
  }

  String? _searchQuery;

  Future<void> _openSearchSheet() async {
    final query = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SearchBottomSheet(),
    );

    if (query != null && query.isNotEmpty) {
      setState(() => _searchQuery = query);
      // Perform search logic here
      debugPrint('🔍 Searching for: $query');
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<JobBloc, JobState>(
                builder: (context, state) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: CustomDefaultPadding(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _openSearchSheet,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _searchQuery ?? 'Search movies...',
                                      style: TextStyle(
                                        color: _searchQuery == null
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_searchQuery != null)
                              Text(
                                'Results for: $_searchQuery',
                                style: const TextStyle(color: Colors.red),
                              ),
                            // _Searchbox(onChanged: _onSearchChanged),
                            const SizedBox(height: 14),
                            Container(
                              // color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSlider = true;
                                          });
                                        },
                                        child: _FilterCard(
                                          isSelected: isSlider,
                                          text: 'Слайдер',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSlider = false;
                                          });
                                        },
                                        child: _FilterCard(
                                          isSelected: !isSlider,
                                          text: 'Список',
                                        ),
                                      ),
                                    ],
                                  ),

                                  InkWell(
                                    onTap: () async {
                                      ApplicantJobFilter(context);
                                    },
                                    child: const CustomImageView(
                                      imagePath: MediaRes.btnFilter,
                                      width: 48,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            state is JobLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : state is JobLoaded
                                ? !isSlider
                                      ? ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              JobListItem(
                                                jobTitle: state
                                                    .jobs
                                                    .jobs[index]
                                                    .title,
                                                salaryRange: state
                                                    .jobs
                                                    .jobs[index]
                                                    .salary
                                                    .toString(),
                                                onTap: () async {
                                                  await ApplicantJobDetail(
                                                    context,
                                                  );
                                                },
                                              ),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 8),
                                          itemCount: state.jobs.jobs.length,
                                        )
                                      : Column(
                                        children: [
                                          Text('jobs ${state.jobs.jobs.length}'),
                                          if(state.jobs.jobs.isNotEmpty)
                                          ApplicantJobSlider(
                                              vacancy: {
                                                'title': state
                                                    .jobs
                                                    .jobs[currentVacancyIndex]
                                                    .title,
                                                'description': state
                                                    .jobs
                                                    .jobs[currentVacancyIndex]
                                                    .description,
                                                'salary': state
                                                    .jobs
                                                    .jobs[currentVacancyIndex]
                                                    .salary
                                                    .toString(),
                                              },
                                              vacancyIndex: currentVacancyIndex,
                                              previousVacancyIndex:
                                                  previousVacancyIndex,
                                              slideDirection: slideDirection,
                                              onInterestedPressed: () {
                                                _handleVacancyReaction(
                                                  isLiked: true,
                                                );
                                              },
                                              onNotInterestedPressed: () {
                                                _handleVacancyReaction(
                                                  isLiked: false,
                                                );
                                              },
                                            ),
                                        ],
                                      )
                                : state is JobError
                                ? Center(child: Text('Error: ${state.message}'))
                                : const SizedBox.shrink(),

                            const SizedBox(height: 16),
                            const _AdCards(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Searchbox extends StatefulWidget {
  final Function(String) onChanged;

  const _Searchbox({required this.onChanged});

  @override
  State<_Searchbox> createState() => _SearchboxState();
}

class _SearchboxState extends State<_Searchbox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      hintText: 'Текст',
      labelText: "Имя",
      controller: _controller,
      // onChanged: widget.onChanged,
      suffixIcon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomImageView(
          imagePath: MediaRes.search,
          width: 12,
          height: 12,
        ),
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
        border: isSelected ? Border.all(color: AppPalette.primaryColor) : null,
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
      child: const Column(
        children: [
          CustomText(
            text: 'Место для рекламы',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF12902A),
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          CustomText(
            text: 'Нажмите, чтобы оставить заявку',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF596574),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
