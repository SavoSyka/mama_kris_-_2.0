import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
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
import 'package:mama_kris/features/emp/emp_resume/presentation/widget/applicant_job_filter.dart';

class EmpResumeScreen extends StatefulWidget {
  const EmpResumeScreen({super.key});

  @override
  _EmpResumeScreenState createState() => _EmpResumeScreenState();
}

class _EmpResumeScreenState extends State<EmpResumeScreen> {
  bool isFavorite = false;

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
                  child: SingleChildScrollView(
                    child: CustomDefaultPadding(
                      child: Column(
                        children: [
                          const _Searchbox(),
                          const SizedBox(height: 14),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isFavorite = true;
                                        });
                                      },
                                      child: _FilterCard(
                                        isSelected: isFavorite,
                                        text: 'Все',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isFavorite = false;
                                        });
                                      },
                                      child: _FilterCard(
                                        isSelected: !isFavorite,
                                        text: 'Избранные',
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    ResumeFilter(context);
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
                          BlocBuilder<ResumeBloc, ResumeState>(
                            builder: (context, state) {
                              if (state is ResumeLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is ResumeErrorState) {
                                return Center(
                                  child: Text('Error: ${state.message}'),
                                );
                              } else if (state is ResumeLoadedState) {
                                final users = state.users.resume;
                                return !isFavorite
                                    ? ListView.separated(
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
                                                );
                                              },
                                            ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 8),
                                        itemCount: users.length,
                                      )
                                    : ListView.separated(
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
                                                );
                                              },
                                            ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 8),
                                        itemCount: users.length,
                                      );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Searchbox extends StatelessWidget {
  const _Searchbox();

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      hintText: 'Текст',
      labelText: "Имя",

      controller: TextEditingController(),
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
