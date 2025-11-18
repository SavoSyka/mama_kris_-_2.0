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
      return BlocProvider(
        create: (context) => sl<CreateJobCubit>(),
        child: const CreateJobPageThree(),
      );
    },
  ),


  GoRoute(
    path: RouteName.resumeDetail,
    name: RouteName.resumeDetail,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpResumeScreenDetail();
    },
  ),



  GoRoute(
    path: RouteName.editProfileEmployee,
    name: RouteName.editProfileEmployee,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpProfileEditScreen();
    },
  ),

  GoRoute(
    path: RouteName.editProfileContactInfoEmployee,
    name: RouteName.editProfileContactInfoEmployee,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};

      return EmpCreateContactScreen(
        contact: extra['contact'] != null
            ? extra['contact'] as ContactEntity
            : null,
      );
    },
  ),

  GoRoute(
    path: RouteName.editProfileBasicInfoEmployee,
    name: RouteName.editProfileBasicInfoEmployee,
    builder: (BuildContext context, GoRouterState state) {
      return BlocProvider(
        create: (context) => sl<EmployeeContactBloc>(),
        child: const EmpProfileEditBasicInfo(),
      );
    },
  ),





];
