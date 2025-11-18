import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_button_applicant.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_state.dart';

class ResumeSpecialitySearchPage extends StatefulWidget {
  final Function(String speciality) onSpecialitySelected;

  const ResumeSpecialitySearchPage({
    Key? key,
    required this.onSpecialitySelected,
  }) : super(key: key);

  @override
  State<ResumeSpecialitySearchPage> createState() => _ResumeSpecialitySearchPageState();
}

class _ResumeSpecialitySearchPageState extends State<ResumeSpecialitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late SpecialitySearchBloc _specialitySearchBloc;

  @override
  void initState() {
    super.initState();
    _specialitySearchBloc = context.read<SpecialitySearchBloc>();
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const CustomText(
              text: 'Выберите специальность',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: CustomInputText(
                  controller: _searchController,
                  hintText: 'Например: Дизайнер, Программист...',
                  labelText: 'Специальность',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  onChanged: (value) => _onSearchChanged(),
                ),
              ),

              const Divider(height: 1),

              // Results
              Expanded(
                child: _buildBody(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(SpecialitySearchState state) {
    if (state is SpecialitySearchLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is SpecialitySearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            CustomText(text: state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            CustomButtonApplicant(
              btnText: 'Повторить',
              onTap: () => _specialitySearchBloc.searchWithDebounce(_searchController.text.trim()),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(imagePath: MediaRes.search ?? '', width: 120),
            const SizedBox(height: 24),
            const CustomText(
              text: 'Начните поиск специальности',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (state is SpecialitySearchLoaded && state.specialities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.grey),
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

    final specialities = state is SpecialitySearchLoaded ? state.specialities : [];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: specialities.length,
      itemBuilder: (context, index) {
        final speciality = specialities[index];
        return InkWell(
          onTap: () => _selectSpeciality(speciality.name),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.work_outline, color: Colors.grey, size: 20),
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
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}