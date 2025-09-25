// import 'dart:convert';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
// import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
// import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
// import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
// import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
// import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
// import 'package:mama_kris/core/common/widgets/custom_text.dart';
// import 'package:mama_kris/core/common/widgets/entity/job_model.dart';
// import 'package:mama_kris/core/constants/app_palette.dart';
// import 'package:mama_kris/core/constants/app_text_contents.dart';
// import 'package:mama_kris/core/constants/media_res.dart';
// import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
// import 'package:mama_kris/core/services/routes/route_name.dart';
// import 'package:mama_kris/features/applicant_home/applications/home/bloc/applicant_home_bloc.dart';
// import 'package:mama_kris/features/applicant_home/applications/search/job_search_cubit.dart';
// import 'package:mama_kris/features/applicant_home/applications/search/job_search_state.dart';
// import 'package:mama_kris/features/applicant_home/applications/search/recent_search_queries.dart';
// import 'package:mama_kris/features/applicant_home/presentation/widget/job_list.dart';
// import 'package:mama_kris/features/home/presentation/widgets/add_job.dart';
// import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
// import 'package:mama_kris/features/home/presentation/widgets/empty_posted_job.dart';
// import 'package:mama_kris/features/home/presentation/widgets/home_bottomsheet/profession_bottomsheet.dart';
// import 'package:mama_kris/widgets/no_more_vacancies_card.dart';

// class ApplicantHomePage extends StatefulWidget {
//   const ApplicantHomePage({super.key});

//   @override
//   State<ApplicantHomePage> createState() => _ApplicantHomePageState();
// }

// class _ApplicantHomePageState extends State<ApplicantHomePage> {
//   final List<String> _tabList = [
//     AppTextContents.active,
//     AppTextContents.drafts,
//     AppTextContents.archive,
//   ];

//   bool isList = false;
//   List<JobModel> _allJobs = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadJobs();
//   }

//   Future<void> loadJobs() async {
//     final String jsonString = await rootBundle.loadString(
//       'assets/json/job.json',
//     );
//     final List<dynamic> jsonData = json.decode(jsonString);
//     setState(() {
//       _allJobs = jsonData.map((e) => JobModel.fromJson(e)).toList();
//       _isLoading = false;
//     });

//     debugPrint("Jobs ${_allJobs.length}");
//   }

//   final Map<String, String> _tabStatusMap = {
//     'Активные': 'active',
//     'Черновики': 'draft',
//     'Архив': 'archived',
//   };

//   List<JobModel> get filteredJobs {
//     return _allJobs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: CustomText(
//                   text: AppTextContents.vacancies,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               SizedBox(height: 20.h),

//               // Search Field
//               GestureDetector(
//                 onTap: () {
//                   _openSearchBottomSheet(context);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppPalette.white,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 8.0),
//                         child: CustomText(text: AppTextContents.search),
//                       ),
//                       CustomImageView(imagePath: MediaRes.search, width: 24),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// buttons filter buttons
//               Padding(
//                 padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         _Cards(
//                           imagePath: MediaRes.slider,
//                           text: AppTextContents.slider,

//                           color: !isList
//                               ? AppPalette.primaryColor
//                               : AppPalette.white,
//                           iconColor: !isList
//                               ? AppPalette.white
//                               : AppPalette.grey,
//                           onTap: () {
//                             setState(() {
//                               isList = false;
//                             });
//                           },
//                         ),
//                         const SizedBox(width: 12),
//                         _Cards(
//                           imagePath: MediaRes.slider,
//                           text: AppTextContents.list,
//                           color: isList
//                               ? AppPalette.primaryColor
//                               : AppPalette.white,
//                           iconColor: isList
//                               ? AppPalette.white
//                               : AppPalette.grey,
//                           onTap: () {
//                             setState(() {
//                               isList = true;
//                             });
//                           },
//                         ),
//                       ],
//                     ),

//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             final filterResult = _openFilterBottomSheet(
//                               context,
//                               ["Developer", "Designer", "Manager", "Tester"],
//                             );

//                             // if (filterResult != null) {
//                             //   print("Price range: ${filterResult['priceRange']}");
//                             //   print(
//                             //     "Selected jobs: ${filterResult['selectedJobs']}",
//                             //   );
//                             // }
//                           },
//                           child: const CustomImageView(
//                             imagePath: MediaRes.btnFilter,
//                             width: 48,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Center(
//                 child: NoMoreVacanciesCard(
//                   onGoToProfile: () {
//                     debugPrint("pressed");
//                     context.replaceNamed(
//                       RouteName.applicantHome,
//                       extra: {'pageIndex': 2},
//                     );
//                     debugPrint("pressed after");
//                   },
//                 ),
//               ),
//               // const EmptyPostedJob()

//               // JobList(jobs: _allJobs),
//               // Expanded(
//               //   child: JobList(jobs: _allJobs, isList: isList),
//               // ),

//               // const EmptyPostedJob(),
//               // SizedBox(height: 24.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _openFilterBottomSheet(BuildContext context, List<String> jobList) {
//     double minPrice = 20.00;
//     double maxPrice = 145.00;
//     RangeValues priceRange = RangeValues(minPrice, maxPrice);

//     // track selected jobs
//     List<String> selectedJobs = [];

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.5,
//               minChildSize: 0.45,
//               maxChildSize: 0.75,
//               builder: (_, scrollController) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: ListView(
//                     controller: scrollController,
//                     children: [
//                       // Drag handle
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           margin: const EdgeInsets.only(bottom: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade400,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),

//                       const Text(
//                         "Filter Jobs",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // Price Range
//                       const Text("Price Range"),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                         children: [
//                           CustomText(
//                             text: "от ${priceRange.start.toInt()} руб",
//                           ),
//                           CustomText(text: "до ${priceRange.end.toInt()} руб"),
//                         ],
//                       ),
//                       RangeSlider(
//                         padding: EdgeInsets.zero,
//                         values: priceRange,
//                         min: minPrice,
//                         max: maxPrice,
//                         divisions: 20,
//                         labels: RangeLabels(
//                           "от ${priceRange.start.toInt()} руб",
//                           "до ${priceRange.end.toInt()} руб",
//                         ),
//                         onChanged: (values) {
//                           setState(() {
//                             priceRange = values;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),

//                       // Job list selection
//                       const Text("Select Jobs"),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: jobList.map((job) {
//                           final isSelected = selectedJobs.contains(job);
//                           return ChoiceChip(
//                             label: CustomText(
//                               text: job,
//                               style: TextStyle(
//                                 color: isSelected
//                                     ? AppPalette.white
//                                     : AppPalette.black,
//                               ),
//                             ),
//                             checkmarkColor: AppPalette.white,
//                             selected: isSelected,
//                             selectedColor: Theme.of(context).primaryColor,
//                             onSelected: (selected) {
//                               setState(() {
//                                 if (selected) {
//                                   selectedJobs.add(job);
//                                 } else {
//                                   selectedJobs.remove(job);
//                                 }
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),

//                       const SizedBox(height: 20),

//                       CustomPrimaryButton(
//                         btnText: 'Apply filters',
//                         onTap: () {
//                           Navigator.pop(context, {
//                             'priceRange': priceRange,
//                             'selectedJobs': selectedJobs,
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   void _openSearchBottomSheet(BuildContext context) async {
//     final TextEditingController searchController = TextEditingController(
//       text: "Дизайнер",
//     );

//     final recentSearchesCubit = getIt<RecentSearchesCubit>();
//     // final jobSearchCubit = getIt<JobSearchCubit>();

//     await recentSearchesCubit.loadRecentSearches();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black.withOpacity(0.3),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: true,
//           initialChildSize: 1,
//           minChildSize: 0.7,
//           maxChildSize: 1,
//           builder: (_, scrollController) {
//             return StatefulBuilder(
//               builder: (context, useState) {
//                 return MultiBlocProvider(
//                   providers: [BlocProvider.value(value: recentSearchesCubit)],
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//                       child: Container(
//                         color: Colors.white.withOpacity(0.7),
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Drag handle
//                             Center(
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 margin: const EdgeInsets.only(bottom: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade400,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                             // Search input
//                             TextField(
//                               controller: searchController,
//                               autofocus: true,
//                               keyboardType: TextInputType.text,
//                               onSubmitted: (value) {
//                                 if (value.isNotEmpty) {
//                                   // recentSearchesCubit.saveSearchQuery(value);
//                                   context.read<JobSearchCubit>().fetchJobs(
//                                     value,
//                                   );
//                                 }
//                                 FocusScope.of(context).unfocus();
//                               },
//                               decoration: InputDecoration(
//                                 hintText: "Search jobs",
//                                 prefixIcon: const Icon(Icons.search),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             // Recent Searches Section
//                             BlocBuilder<
//                               RecentSearchesCubit,
//                               RecentSearchesState
//                             >(
//                               builder: (context, state) {
//                                 debugPrint("state $state");
//                                 if (state is RecentSearchesLoading) {
//                                   return const Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 } else if (state is RecentSearchesLoaded &&
//                                     state.searches.isNotEmpty) {
//                                   return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const Text(
//                                             "Recent searches",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               context
//                                                   .read<RecentSearchesCubit>()
//                                                   .clearRecentSearches();
//                                             },
//                                             child: const Text("Clear all"),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 10),
//                                       Wrap(
//                                         spacing: 6,
//                                         runSpacing: 6,
//                                         children: state.searches.map((search) {
//                                           return GestureDetector(
//                                             onTap: () {
//                                               searchController.text =
//                                                   search.title;
//                                             },
//                                             child: Chip(
//                                               label: Text(search.title),
//                                               deleteIcon: const Icon(
//                                                 Icons.close,
//                                                 size: 16,
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                               materialTapTargetSize:
//                                                   MaterialTapTargetSize
//                                                       .shrinkWrap,
//                                               visualDensity:
//                                                   VisualDensity.compact,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(6),
//                                               ),
//                                               onDeleted: () {
//                                                 recentSearchesCubit
//                                                     .removeSearchQuery(
//                                                       search.title,
//                                                     );

//                                                 useState(() {});
//                                               },
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                       const SizedBox(height: 20),
//                                     ],
//                                   );
//                                 } else if (state is RecentSearchesError) {
//                                   return Text("Error: ${state.message}");
//                                 }
//                                 return const SizedBox.shrink();
//                               },
//                             ),
//                             // Job Search Results
//                             Expanded(
//                               child:
//                                   BlocBuilder<JobSearchCubit, JobSearchState>(
//                                     builder: (context, state) {
//                                       debugPrint("Search state $state");
//                                       if (state is JobsLoading) {
//                                         return const Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       } else if (state is JobsLoaded) {
//                                         if (state.jobs.isEmpty) {
//                                           return const Center(
//                                             child: Text("No jobs found"),
//                                           );
//                                         }
//                                         return ListView.builder(
//                                           controller: scrollController,
//                                           itemCount: state.jobs.length,
//                                           itemBuilder: (context, index) {
//                                             return ListTile(
//                                               title: Text(
//                                                 state.jobs[index].title,
//                                               ),
//                                               onTap: () {
//                                                 Navigator.pop(
//                                                   context,
//                                                   state.jobs[index],
//                                                 );

//                                                 context
//                                                     .read<ApplicantHomeBloc>()
//                                                     .add(
//                                                       SearchCombinedEvent(
//                                                         query: state
//                                                             .jobs[index]
//                                                             .title,
//                                                       ),
//                                                     );
//                                               },
//                                             );
//                                           },
//                                         );
//                                       } else if (state is JobsError) {
//                                         return Center(
//                                           child: Text(state.message),
//                                         );
//                                       }
//                                       return const Center(
//                                         child: Text(
//                                           "Enter a search term to find jobs",
//                                         ),
//                                       );
//                                     },
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class _Cards extends StatelessWidget {
//   const _Cards({
//     super.key,
//     this.imagePath,
//     this.text,
//     this.color,
//     this.iconColor,
//     this.onTap,
//   });
//   final String? imagePath;
//   final String? text;
//   final Color? color;
//   final Color? iconColor;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         decoration: BoxDecoration(
//           color: color ?? AppPalette.white,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           spacing: 6,
//           children: [
//             if (imagePath != null)
//               CustomImageView(
//                 imagePath: imagePath,
//                 width: 12,
//                 color: iconColor ?? AppPalette.grey,
//               ),
//             if (text != null)
//               CustomText(
//                 text: text!,
//                 style: TextStyle(
//                   color: iconColor ?? AppPalette.black,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
