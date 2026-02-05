import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/job_list_item.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/core/utils/build_base64image.dart';
import 'package:mama_kris/core/utils/handle_launch_url.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/ads_cubit.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/ads_state.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_state.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_state.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_filter.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_slider.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/empty_job_view.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/filter_action_buttons.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/home_search_page.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/widget/resume_speciality_search_page.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';

class ApplHomeScreen extends StatefulWidget {
  const ApplHomeScreen({super.key});

  @override
  _ApplHomeScreenState createState() => _ApplHomeScreenState();
}

class _ApplHomeScreenState extends State<ApplHomeScreen> {
  ///
  // * ────────────────────── State Variable declarations Started ───────────────────────

  int currentVacancyIndex = 0;
  int previousVacancyIndex = 0;
  int slideDirection = -1;
  bool isSlider = true;

  String? _searchQuery;
  String? _minSalary;
  String? _maxSalary;
  bool? _byAgreement;

  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  // * ────────────────────── State Variable declarations ended  ───────────────────────

  // * ────────────────────── Overrided Methods ───────────────────────

  @override
  void initState() {
    super.initState();
    handleFetchJobs();
    context.read<AdsCubit>().fetchAds();
    context.read<PublicCountsBloc>().add(FetchPublicCountsEvent());
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  // * ────────────── BUILD UI Started Ended ───────────────────────

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
          child: BlocListener<JobBloc, JobState>(
            listener: (context, state) {
              // Check for 403 subscription required error
              if (state is JobError) {
                final errorMessage = state.message.toLowerCase();
                print(errorMessage);
                // Check if error message contains subscription required message
                if (errorMessage.contains('402')) {
                  context.pushReplacementNamed(RouteName.subscription);
                }
              }
            },
            child: BlocBuilder<JobBloc, JobState>(
              builder: (context, state) {
                // ---------- Loading ----------
                if (state is JobLoading) {
                  return const Center(child: IPhoneLoader(height: 200));
                }

                // ---------- Error ----------
                if (state is JobError) {
                  return Center(
                    child: CustomErrorRetry(
                      errorMessage: state.message,
                      onTap: () => handleFetchJobs(),
                    ),
                  );
                }

                // inside your BlocBuilder when state is JobLoaded
                if (state is JobLoaded) {
                  final jobs = state.jobs.jobs;

                  if (jobs.isEmpty) {
                    return Container(
                      child: EmptyJobView(onRefresh: _handleRefresh),
                    );
                  }

                  return SizedBox(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: AppPalette.primaryColor,
                      backgroundColor: Colors.white,
                      displacement: 40,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _calculateItemCount(
                          jobs.length,
                          state.jobs.hasNextPage,
                          isSlider,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // ---------- Top Section (header/search/filter) ----------
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ---------- Search Field ----------
                                GestureDetector(
                                  onTap: _openSearchPage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
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
                                          _searchQuery ?? 'Search jobs...',
                                          style: TextStyle(
                                            color: _searchQuery == null
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // ---------- Filter Buttons ----------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              setState(() => isSlider = true),
                                          child: FilterActionButtons(
                                            isSelected: isSlider,
                                            text: 'Слайдер',
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        InkWell(
                                          onTap: () =>
                                              setState(() => isSlider = false),
                                          child: FilterActionButtons(
                                            isSelected: !isSlider,
                                            text: 'Список',
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final filter = await ApplicantJobFilter(
                                          context,
                                        );
                                        if (filter != null) {
                                          _applyFilters(filter);
                                        }
                                      },
                                      child: const CustomImageView(
                                        imagePath: MediaRes.btnFilter,
                                        width: 48,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                              ],
                            );
                          }

                          // For indices > 0:
                          final contentIndex = index - 1;

                          // ---------- If Slider mode: show slider in a single slot ----------
                          if (isSlider) {
                            // We placed the slider as the first content slot (index==1)
                            if (contentIndex == 0) {
                              // Ensure currentVacancyIndex is within bounds
                              if (jobs.isEmpty) {
                                // fallback empty placeholder
                                return const SizedBox.shrink();
                              }
                              final safeIndex = currentVacancyIndex.clamp(
                                0,
                                jobs.length - 1,
                              );
                              final job = jobs[safeIndex];

                              return Column(
                                children: [
                                  ApplicantJobSlider(
                                    vacancy: {
                                      'title': job.title,
                                      'description': job.description,
                                      'salary': job.salary.toString(),
                                    },
                                    vacancyIndex: currentVacancyIndex,
                                    previousVacancyIndex: previousVacancyIndex,
                                    slideDirection: slideDirection,
                                    onInterestedPressed: () {
                                      _handleVacancyReaction(isLiked: true);
                                    },
                                    onNotInterestedPressed: () {
                                      _handleVacancyReaction(isLiked: false);
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Public Counts
                                  BlocBuilder<
                                    PublicCountsBloc,
                                    PublicCountsState
                                  >(
                                    builder: (context, state) {
                                      if (state is PublicCountsLoaded) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 0,
                                          ),

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${state.counts.users}+ мам',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              const SizedBox(width: 40),
                                              Text(
                                                '${state.counts.jobs} вакансий',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),

                                  const SizedBox(height: 16),
                                  const _AdCards(),
                                ],
                              );
                            }

                            // If slider mode and there's nothing else to show, just shrink
                            return const SizedBox.shrink();
                          }

                          // ---------- List mode ----------
                          if (!isSlider) {
                            int ads = jobs.length ~/ 3;
                            int totalContent = jobs.length + ads;
                            if (contentIndex < totalContent) {
                              if ((contentIndex + 1) % 4 == 0) {
                                // Ad card
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: const _AdCards(),
                                );
                              } else {
                                int jobIndex =
                                    contentIndex - (contentIndex ~/ 4);
                                final job = jobs[jobIndex];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: JobListItem(
                                    jobTitle: job.title,
                                    salaryRange: job.salary.toString(),
                                    jobId: job.jobId,
                                    contactJobs: job.contactJobs,
                                    onTap: () async {
                                      // Mark job as viewed when opened
                                      context.read<JobBloc>().add(
                                        ViewJobEvent(job.jobId),
                                      );
                                      await ApplicantJobDetail(
                                        context,
                                        job: job,
                                        onLiked: () async {
                                          context.read<JobBloc>().add(
                                            LikeJobEvent(job.jobId),
                                          );
                                          Navigator.maybePop(context);
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                            } else if (contentIndex == totalContent &&
                                state.jobs.hasNextPage) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: IPhoneLoader(),
                              );
                            }
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  );
                }

                // ---------- Default Empty ----------
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  // * 0. ────────────────────── SCROLL LISTENER ───────────────────────
  void _scrollListener() {
    //0. check if it not slider.
    if (isSlider) return;
    // 1. Not a loaded state → ignore

    final state = context.read<JobBloc>().state;
    if (state is! JobLoaded) return;

    // 2. Already loading more or no next page → ignore
    if (state.isLoadingMore || !state.jobs.hasNextPage) return;

    // 3. Not near the bottom (80 % of max) → ignore
    final max = _scrollController.position.maxScrollExtent;
    final cur = _scrollController.position.pixels;
    if (cur < max * 0.8) return;

    // 4. Debounce – fire **once** every seconds
    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      final nextPage = state.jobs.currentPage + 1;
      _loadMoreJobs(nextPage);
    });
  }

  // * 1. ────────────── Helper functions started ───────────────────────

  void _loadMoreJobs(int page) {
    context.read<JobBloc>().add(
      LoadNextJobsPageEvent(
        page,
        title: _searchQuery,
        minSalary: _minSalary,
        maxSalary: _maxSalary,
        salaryWithAgreement: _byAgreement,
      ),
    );
  }

  void _handleFilters() {
    context.read<JobBloc>().add(
      FilterJobEvent(
        page: 1,
        perPage: 10,
        title: _searchQuery,
        minSalary: _minSalary,
        maxSalary: _maxSalary,
        salaryWithAgreement: _byAgreement,
      ),
    );
  }

  void handleFetchJobs() {
    context.read<JobBloc>().add(FetchJobsEvent());
  }

  Future<void> _handleVacancyReaction({required bool isLiked}) async {
    final bloc = context.read<JobBloc>();
    final state = bloc.state;

    if (state is! JobLoaded || state.jobs.jobs.isEmpty) return;

    final jobs = state.jobs.jobs;
    final currentJobIndex = currentVacancyIndex.clamp(0, jobs.length - 1);
    final currentJob = jobs[currentJobIndex];

    debugPrint("🧩 Current job index: $currentJobIndex | Liked: $isLiked");

    // Mark job as viewed when opened (before like/dislike action)
    bloc.add(ViewJobEvent(currentJob.jobId));

    // Dispatch like/dislike event
    if (isLiked) {
      await ApplicantJobDetail(
        context,
        job: currentJob,
        onLiked: () async {
          context.read<JobBloc>().add(LikeJobEvent(currentJob.jobId));
          Navigator.maybePop(context);
        },
      );
      bloc.add(LikeJobEvent(currentJob.jobId));
    } else {
      bloc.add(DislikeJobEvent(currentJob.jobId));
    }

    // ---- Optimistic UI update ----
    setState(() {
      previousVacancyIndex = currentJobIndex;
      slideDirection = isLiked ? -1 : 1;

      // If more jobs remain, move to next
      if (currentJobIndex < jobs.length - 1) {
        if (isLiked) {
          currentVacancyIndex = currentJobIndex != 0 ? currentJobIndex - 1 : 0;
        } else {
          currentVacancyIndex = currentJobIndex + 1;
        }
      } else {
        // If we're at the end, loop or stop safely
        currentVacancyIndex = jobs.isNotEmpty ? jobs.length - 1 : 0;
      }
    });

    // ---- Pagination trigger ----
    // Fetch next page when near end of list
    final hasFewJobsLeft = (jobs.length - currentJobIndex) <= 2;
    if (hasFewJobsLeft && state.jobs.hasNextPage) {
      final nextPage = state.jobs.currentPage + 1;
      debugPrint("📡 Fetching next page: $nextPage");
      bloc.add(
        LoadNextJobsPageEvent(
          nextPage,
          title: _searchQuery,
          minSalary: _minSalary,
          maxSalary: _maxSalary,
          salaryWithAgreement: _byAgreement,
        ),
      );
    }
  }

  Future<void> _handleRefresh() async {
    handleFetchJobs();
    await context.read<JobBloc>().stream.firstWhere(
      (state) => state is JobLoaded || state is JobError,
    );
    context.read<AdsCubit>().fetchAds();
  }

  void _onSearchChanged(String query) {
    context.read<JobBloc>().add(SearchJobsEvent(query));
  }

  void _openSearchPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeSpecialitySearchPage(
          isApplicant: true,
          onSpecialitySelected: (selectedSpeciality) {
            if (selectedSpeciality.isNotEmpty &&
                _searchQuery != selectedSpeciality) {
              setState(() {
                _searchQuery = selectedSpeciality;
              });

              _handleFilters();
            }
            // Do whatever you want with the selected speciality
            print('Selected: $selectedSpeciality');
          },
        ),
      ),
    );
  }

  // Future<void> _openSearchPage() async {
  //   final query = await Navigator.of(
  //     context,
  //   ).push<String>(MaterialPageRoute(builder: (_) => const HomeSearchPage()));

  //   if (query != null && query.isNotEmpty) {
  //     setState(() => _searchQuery = query);
  //     _handleFilters();
  //     // Trigger your Bloc search event

  //     debugPrint('Searching for: $query');
  //   }
  // }

  int _calculateItemCount(int jobsLength, bool hasNextPage, bool isSliderMode) {
    // 1 for header + content
    if (isSliderMode) {
      // header + 1 slot for slider
      return 1 + 1;
    } else {
      // header + jobs + ads + optional bottom loader
      int ads = jobsLength ~/ 3;
      return 1 + jobsLength + ads + (hasNextPage ? 1 : 0);
    }
  }

  void _applyFilters(DataMap filter) {
    debugPrint("FIlter $filter");

    if (filter['agreement'] != null && (filter['agreement'] as bool) == true) {
      debugPrint("BY Agreemenet ${filter['agreement']}");

      setState(() {
        _byAgreement = true;
        _minSalary = null;
        _maxSalary = null;
      });

      _handleFilters();
    } else {
      final min = filter['min'].toString();
      final max = filter['max'].toString();

      setState(() {
        _byAgreement = false;
        _minSalary = min;
        _maxSalary = max;
      });

      _handleFilters();
      debugPrint("minimum and maimum $min, ... $max");
    }
  }

  // * ────────────── Helper functions Ended ───────────────────────
}

class _AdCards extends StatelessWidget {
  const _AdCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: AppTheme.cardDecoration,
      child: BlocBuilder<AdsCubit, AdsState>(
        builder: (context, state) {
          if (state is AdsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is AdsLoaded) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (state.ad.link.isNotEmpty) {
                            HandleLaunchUrl.launchUrlGeneric(
                              context,
                              url: state.ad.link,
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: buildBase64Image(state.ad.imageData),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AdsError)
            CustomErrorRetry(onTap: () {});

          return const Text("che");
        },
      ),
    );
  }
}
