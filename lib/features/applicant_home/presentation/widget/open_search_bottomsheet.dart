import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/applicant_home/applications/search/recent_search_queries.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/applicant_home/applications/home/bloc/applicant_home_bloc.dart';
import 'package:mama_kris/features/applicant_home/applications/search/job_search_cubit.dart';
import 'package:mama_kris/features/applicant_home/applications/search/job_search_state.dart';
import 'package:mama_kris/features/applicant_home/applications/search/recent_search_queries.dart';

void homeOpenSearchBottomSheet(BuildContext context) async {
  final TextEditingController searchController = TextEditingController(
    text: "Дизайнер",
  );

  final recentSearchesCubit = getIt<RecentSearchesCubit>();
  // final jobSearchCubit = getIt<JobSearchCubit>();

  await recentSearchesCubit.loadRecentSearches();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: true,
        initialChildSize: 1,
        minChildSize: 0.7,
        maxChildSize: 1,
        builder: (_, scrollController) {
          return StatefulBuilder(
            builder: (context, useState) {
              return MultiBlocProvider(
                providers: [BlocProvider.value(value: recentSearchesCubit)],
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          // Search input
                          TextField(
                            controller: searchController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                // recentSearchesCubit.saveSearchQuery(value);
                                context.read<JobSearchCubit>().fetchJobs(value);
                              }
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "Search jobs",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Recent Searches Section
                          BlocBuilder<RecentSearchesCubit, RecentSearchesState>(
                            builder: (context, state) {
                              debugPrint("state $state");
                              if (state is RecentSearchesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is RecentSearchesLoaded &&
                                  state.searches.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Recent searches",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<RecentSearchesCubit>()
                                                .clearRecentSearches();
                                          },
                                          child: const Text("Clear all"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: state.searches.map((search) {
                                        return GestureDetector(
                                          onTap: () {
                                            searchController.text =
                                                search.title;
                                          },
                                          child: Chip(
                                            label: Text(search.title),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            onDeleted: () {
                                              recentSearchesCubit
                                                  .removeSearchQuery(
                                                    search.title,
                                                  );

                                              useState(() {});
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              } else if (state is RecentSearchesError) {
                                return Text("Error: ${state.message}");
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          // Job Search Results
                          Expanded(
                            child: BlocBuilder<JobSearchCubit, JobSearchState>(
                              builder: (context, state) {
                                debugPrint("Search state $state");
                                if (state is JobsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is JobsLoaded) {
                                  if (state.jobs.isEmpty) {
                                    return const Center(
                                      child: Text("No jobs found"),
                                    );
                                  }
                                  return ListView.builder(
                                    controller: scrollController,
                                    itemCount: state.jobs.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(state.jobs[index].title),
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                            state.jobs[index],
                                          );

                                          context.read<ApplicantHomeBloc>().add(
                                            SearchCombinedEvent(
                                              query: state.jobs[index].title,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else if (state is JobsError) {
                                  return Center(child: Text(state.message));
                                }
                                return const Center(
                                  child: Text(
                                    "Enter a search term to find jobs",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
