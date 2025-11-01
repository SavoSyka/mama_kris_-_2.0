part of '../router.dart';

final List<RouteBase> employeRoutes = [
  GoRoute(
    path: RouteName.homeEmploye,
    name: RouteName.homeEmploye,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra != null
          ? state.extra as DataMap
          : {"pageIndex": 0};
      debugPrint("extra $extra");
      return EmpHomeTabScreen(pageIndex: extra['pageIndex'] as int);
    },
  ),

  GoRoute(
    path: RouteName.createJobPageOne,
    name: RouteName.createJobPageOne,
    builder: (BuildContext context, GoRouterState state) {
      return const CreateJobPageOne();
    },
  ),

GoRoute(
  path: RouteName.createJobPageTwo,
  name: RouteName.createJobPageTwo,
  builder: (BuildContext context, GoRouterState state) {
    // Receive data passed via extra
    final extra = state.extra as Map<String, dynamic>? ?? {};

    final salary = extra['salary'];
    final speciality = extra['speciality'];
    final description = extra['description'];
    final salaryWithAgreement = extra['salaryWithAgreement'];
    final contactAddresses = extra['contactAddresses'];
    final links = extra['links'];

    return CreateJobPageTwo(
      salary: salary,
      speciality: speciality,
      description: description,
      salaryWithAgreement: salaryWithAgreement,
    );
  },
),


GoRoute(
  path: RouteName.createJobPageThree,
  name: RouteName.createJobPageThree,
  builder: (BuildContext context, GoRouterState state) {
    // Receive data passed via extra
    final extra = state.extra as Map<String, dynamic>? ?? {};

    final salary = extra['salary'];
    final speciality = extra['speciality'];
    final description = extra['description'];
    final salaryWithAgreement = extra['salaryWithAgreement'];
    final contactAddresses = extra['contactAddresses'];
    final links = extra['links'];

    return CreateJobPageThree(
      salary: salary,
      speciality: speciality,
      description: description,
      salaryWithAgreement: salaryWithAgreement,
      contactAddresses: contactAddresses,
      links: links,
    );
  },
),



  GoRoute(
    path: RouteName.employesHome,
    name: RouteName.employesHome,
    builder: (BuildContext context, GoRouterState state) {
      return const EmployeTabScreen();
    },
  ),

  GoRoute(
    path: RouteName.resumeDetail,
    name: RouteName.resumeDetail,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpResumeScreenDetail();
    },
  ),



];
