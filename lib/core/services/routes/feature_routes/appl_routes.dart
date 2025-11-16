part of '../router.dart';

final List<RouteBase> jobRoutes = [
  /*
  GoRoute(
    path: RouteName.applicantHome,
    name: RouteName.applicantHome,
    pageBuilder: (context, state) {
      debugPrint("reach");
      final extra = state.extra != null ? state.extra as DataMap : {"page": 0};

      final page = extra['page'] is int
          ? extra['page'] as int
          : int.tryParse(extra['page'].toString()) ?? 0;

      return CustomTransitionPage(
        key: state.pageKey,
        child: MainScreen(initialIndex: page),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  ),
*/
  GoRoute(
    path: RouteName.homeApplicant,
    name: RouteName.homeApplicant,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra != null
          ? state.extra as DataMap
          : {"pageIndex": 0};
      debugPrint("extra $extra");
      return ApplHomeTabScreen(pageIndex: extra['pageIndex'] as int);
    },
  ),


  GoRoute(
    path: RouteName.editProfileApplicant,
    name: RouteName.editProfileApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplProfileEditScreen();
    },
  ),

  GoRoute(
    path: RouteName.editProfileContactInfoApplicant,
    name: RouteName.editProfileContactInfoApplicant,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};

      return ApplCreateContactScreen(
        contact: extra['contact'] != null
            ? extra['contact'] as ApplContactEntity
            : null,
      );
    },
  ),

  GoRoute(
    path: RouteName.editProfileBasicInfoApplicant,
    name: RouteName.editProfileBasicInfoApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplProfileEditBasicInfo();
    },
  ),

  GoRoute(
    path: RouteName.editProfileworkExpereinceInfoApplicant,
    name: RouteName.editProfileworkExpereinceInfoApplicant,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};


      return  ApplProfileEditWorkExperience(
          experience: extra['experience'] != null
            ? extra['experience'] as ApplWorkExperienceEntity
            : null,
      );
    },
  ),

  GoRoute(
    path: RouteName.editProfileEducationInfoApplicant,
    name: RouteName.editProfileEducationInfoApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplProfileEditWorkExperience();
    },
  ),

  /*


  static String editProfileBasicInfoApplicant = '/$_applicant/edit-basic-info';
  static String editProfileContactInfoApplicant = '/$_applicant/edit-contact-info';
  static String editProfileworkExpereinceInfoApplicant = '/$_applicant/edit-work-expereince';
  static String editProfileEducationInfoApplicant = '/$_applicant/edit-education-info';

*/
];
