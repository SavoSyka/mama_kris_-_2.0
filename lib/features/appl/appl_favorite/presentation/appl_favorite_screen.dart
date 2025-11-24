import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/job_list_item.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/bloc/liked_job_bloc_bloc.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/widget/empty_favorite_job.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/widget/applicant_job_detail.dart';

class ApplFavoriteScreen extends StatefulWidget {
  const ApplFavoriteScreen({super.key});

  @override
  _ApplFavoriteScreenState createState() => _ApplFavoriteScreenState();
}

class _ApplFavoriteScreenState extends State<ApplFavoriteScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  // * ────────────────────── State Variable declarations ended  ───────────────────────

  // * ────────────────────── Overrided Methods ───────────────────────

  @override
  void initState() {
    super.initState();
    handleFetchJobs();
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
        title: 'Мои заказы',
        showLeading: false,
        alignTitleToEnd: false,
      ),

      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: CustomDefaultPadding(
            top: 0,
            bottom: 0,
            child: BlocBuilder<LikedJobBlocBloc, LikedJobBlocState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    if (state is LikedJobLoading)
                      const Expanded(
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(child: IPhoneLoader(height: 200)),
                            ],
                          ),
                        ),
                      )
                    else if (state is LikedJobError)
                      Expanded(
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomErrorRetry(
                                  hasDefaultMargin: true,
                                  errorMessage: state.message,
                                  onTap: _handleRefresh,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state is LikedJobLoadedState)
                      state.jobs.likedJob.isEmpty
                          ? Expanded(
                              child: EmptyFavoriteJob(
                                title: "No Favorite Jobs Found",
                                onRefresh: _handleRefresh,
                              ),
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                onRefresh: _handleRefresh,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index < state.jobs.likedJob.length) {
                                      final job = state.jobs.likedJob[index];
                                      return JobListItem(
                                        jobTitle: job.job.title,
                                        jobId: job.job.jobId,
                                        salaryRange: job.job.salary.toString(),
                                        showAddToFavorite: false,
                                      contactJobs: job.job.contactJobs,

                                        onTap: () async =>
                                            await ApplicantJobDetail(
                                              context,
                                              job: job.job,
                                              showStar: false,

                                              onLiked: () async {
                                                context.read<JobBloc>().add(
                                                  LikeJobEvent(job.jobId),
                                                );
                                                Navigator.maybePop(context);
                                              },
                                            ),

                                        onDislike: () =>
                                            onDislikeJob(job.jobId),
                                      );
                                    } else if (state.jobs.hasNextPage) {
                                      // Loader at bottom
                                      return const IPhoneLoader();
                                    }
                                    return null;
                                  },
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemCount: state.jobs.likedJob.length + 1,
                                ),
                              ),
                            ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // * 0. ────────────────────── SCROLL LISTENER ───────────────────────
  void _scrollListener() {
    // 1. Not a loaded state → ignore
    final state = context.read<LikedJobBlocBloc>().state;
    // debugPrint("scrolling ${state.runtimeType}");

    if (state is! LikedJobLoadedState) return;

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
    context.read<LikedJobBlocBloc>().add(LikedLoadNextJobsPageEvent(page));
  }

  Future<void> handleFetchJobs() async {
    context.read<LikedJobBlocBloc>().add(const FetchLikedJobEvent());
  }

  Future<void> _handleRefresh() async {
    handleFetchJobs();
    await context.read<LikedJobBlocBloc>().stream.firstWhere(
      (state) => state is LikedJobLoadedState || state is LikedJobError,
    );
  }

  Future<void> onDislikeJob(int jobId) async {
    context.read<LikedJobBlocBloc>().add(RemovingLikedJobs(jobId: jobId));
    context.read<JobBloc>().add(DislikeJobEvent(jobId));
  }
}
