import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_empty_container.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/common/widgets/resume_item.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_state.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/widget/resume_speciality_search_page.dart';

class EmpResumeScreen extends StatefulWidget {
  const EmpResumeScreen({super.key});

  @override
  _EmpResumeScreenState createState() => _EmpResumeScreenState();
}

class _EmpResumeScreenState extends State<EmpResumeScreen> {
  // * ────────────────────── State Variable declarations ended  ───────────────────────

  bool isFavorite = false;
  String _searchQuery = '';

  // * ────────────────────── Overriding Methods  ───────────────────────

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadResumes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          context.read<ResumeBloc>()
            ..add(FetchResumesEvent(isFavorite: isFavorite)),
      child: CustomScaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
          title: 'Резюме',
          showLeading: false,
          alignTitleToEnd: false,
        ),
        body: Container(
          decoration: const BoxDecoration(color: AppPalette.empBgColor),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,

                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: CustomDefaultPadding(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _onFiltering,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
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
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (isFavorite) {
                                            setState(() {
                                              isFavorite = false;
                                            });
                                            _loadResumes();
                                          }
                                        },
                                        child: _FilterCard(
                                          isSelected: !isFavorite,
                                          text: 'Все',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          if (!isFavorite) {
                                            setState(() {
                                              isFavorite = true;
                                            });
                                            _loadResumes();
                                          }
                                        },
                                        child: _FilterCard(
                                          isSelected: isFavorite,
                                          text: 'Избранные',
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: _onFiltering,
                                    child: const CustomImageView(
                                      imagePath: MediaRes.btnFilter,
                                      width: 48,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            BlocBuilder<ResumeBloc, ResumeState>(
                              builder: (context, state) {
                                if (state is ResumeLoadingState) {
                                  return const IPhoneLoader();
                                } else if (state is ResumeErrorState) {
                                  return Center(
                                    child: Text('Error: ${state.message}'),
                                  );
                                } else if (state is ResumeLoadedState) {
                                  final users = state.users.resume;

                                  if (users.isEmpty) {
                                    return const CustomEmptyContainer();
                                  } else {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          ResumeItem(
                                            name: users[index].name,
                                            role: users[index].role,
                                            age: users[index].age,
                                            onTap: () async {
                                              context.pushNamed(
                                                RouteName.resumeDetail,
                                                extra: {
                                                  'userId': users[index].id
                                                      .toString(),
                                                },
                                              );
                                            },
                                          ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 8),
                                      itemCount: users.length,
                                    );
                                  }
                                } else {
                                  return const Center(child: Text('No data'));
                                }
                              },
                            ),
                            const SizedBox(height: 16),
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
      ),
    );
  }

  // * ────────────────────── Helper Methods ───────────────────────
  void _loadResumes() {
    if (!isFavorite) {
      context.read<ResumeBloc>().add(FetchResumesEvent(isFavorite: isFavorite));
    } else {
      context.read<ResumeBloc>().add(const FetchFavoritedResumesEvent());
    }
  }

  void _loadMoreResumes(int page) {
    if (!isFavorite) {
      context.read<ResumeBloc>().add(LoadNextResumePageEvent(nextPage: page));
    } else {
      context.read<ResumeBloc>().add(
        LoadNextFavoritedResumePageEvent(nextPage: page),
      );
    }
  }

  void filterBasedOnSpecilaity() {
    context.read<ResumeBloc>().add(
      FetchResumesEvent(isFavorite: isFavorite, searchQuery: _searchQuery),
    );
  }

  void _onFiltering() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeSpecialitySearchPage(
          onSpecialitySelected: (selectedSpeciality) {
            if (selectedSpeciality.isNotEmpty &&
                _searchQuery != selectedSpeciality) {
              setState(() {
                _searchQuery = selectedSpeciality;
              });

              filterBasedOnSpecilaity();
            }
            // Do whatever you want with the selected speciality
            print('Selected: $selectedSpeciality');
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _loadResumes();
    await context.read<ResumeBloc>().stream.firstWhere(
      (state) => state is ResumeLoadedState || state is ResumeErrorState,
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
