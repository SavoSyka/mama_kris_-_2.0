import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar_without.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_state.dart';

class ResumeSpecialitySearchPage extends StatefulWidget {
  final Function(String speciality) onSpecialitySelected;
  final bool isApplicant;

  const ResumeSpecialitySearchPage({
    super.key,
    this.isApplicant = false,
    required this.onSpecialitySelected,
  });

  @override
  State<ResumeSpecialitySearchPage> createState() =>
      _ResumeSpecialitySearchPageState();
}

class _ResumeSpecialitySearchPageState
    extends State<ResumeSpecialitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late SpecialitySearchBloc _specialitySearchBloc;

  @override
  void initState() {
    super.initState();
    _specialitySearchBloc = context.read<SpecialitySearchBloc>();

    // Load search history on first open
    _specialitySearchBloc.add(LoadSearchHistoryEvent());

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _specialitySearchBloc.searchWithDebounce(query);
  }

  void _selectSpeciality(String speciality) {
    widget.onSpecialitySelected(speciality);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialitySearchBloc, SpecialitySearchState>(
      builder: (context, state) {
        return CustomScaffold(
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(
            title: 'Выберите специальность',
            showLeading: true,
            alignTitleToEnd: true,
          ),
          body: Container(
            decoration: widget.isApplicant
                ? const BoxDecoration(gradient: AppTheme.primaryGradient)
                : const BoxDecoration(color: AppPalette.empBgColor),
            child: SafeArea(
              child: Column(
                children: [
                  /// ---------- iOS-style Search Field ----------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: CustomInputText(
                      controller: _searchController,
                      hintText: 'Например: Дизайнер, Программист...',
                      labelText: '',
                      autoFocus: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),

                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      onChanged: (_) => _onSearchChanged(),
                    ),
                  ),

                  /// Divider with subtle opacity
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  /// ---------- Results ----------
                  Expanded(child: _buildBody(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(SpecialitySearchState state) {
    if (state is SpecialitySearchLoading) {
      return const Center(
        child: IPhoneLoader(),
        // CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is SpecialitySearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            CustomText(
              text: state.message,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            CustomButtonApplicant(
              btnText: 'Повторить',
              onTap: () => _specialitySearchBloc.searchWithDebounce(
                _searchController.text.trim(),
              ),
            ),
          ],
        ),
      );
    }

    /// ---------- Initial State with Search History ----------
    if (_searchController.text.isEmpty && state is SearchHistoryLoaded) {
      if (state.searchHistory.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              CustomText(
                text: 'Начните поиск специальности',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      } else {
        return _buildSearchHistory(state.searchHistory);
      }
    }

    /// ---------- Empty Results ----------
    if (state is SpecialitySearchLoaded && state.specialities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_dissatisfied,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'Ничего не найдено по запросу\n"${_searchController.text}"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    /// ---------- Results List ----------
    final specialities = state is SpecialitySearchLoaded
        ? state.specialities
        : [];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: specialities.length,
      itemBuilder: (context, index) {
        final speciality = specialities[index];
        return InkWell(
          onTap: () => _selectSpeciality(speciality.name),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: Colors.grey.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    text: speciality.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.withOpacity(0.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchHistory(List<String> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: CustomText(
            text: 'Недавние поиски',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final query = history[index];
              return InkWell(
                onTap: () {
                  _searchController.text = query;
                  _selectSpeciality(query);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Colors.grey.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomText(
                          text: query,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.withOpacity(0.5)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
