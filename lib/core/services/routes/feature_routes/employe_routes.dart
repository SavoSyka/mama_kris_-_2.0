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
      final extra = state.extra as Map<String, dynamic>? ?? {};

      final jobEntity = extra['job'] as EmpJobEntity?;
      return CreateJobPageOne(job: jobEntity);
    },
  ),

  GoRoute(
    path: RouteName.createJobPageTwo,
    name: RouteName.createJobPageTwo,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};

      final jobEntity = extra['job'] as EmpJobEntity?;
      final newContact = extra['newContact'] as ContactEntity?;

      // If we have a new contact, create a job entity with it
      EmpJobEntity? finalJobEntity = jobEntity;
      if (newContact != null) {
        finalJobEntity = EmpJobEntity(
          jobId: 0,
          userId: 0,
          contactsId: newContact.contactsID ?? 0,
          title: '',
          description: '',
          salary: '',
          status: 'draft',
          dateTime: '',
          contactJobs: ContactJobs(
            contactsID: newContact.contactsID,
            name: newContact.name,
            telegram: newContact.telegram,
            email: newContact.email,
            phone: newContact.phone,
            whatsapp: newContact.whatsapp,
            vk: newContact.vk,
            link: newContact.link,
          ),
        );
      }

      return CreateJobPageTwo(job: finalJobEntity);
    },
  ),

  GoRoute(
    path: RouteName.createJobPageThree,
    name: RouteName.createJobPageThree,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};

      final jobEntity = extra['job'] as EmpJobEntity?;

      return BlocProvider(
        create: (context) => sl<CreateJobCubit>(),
        child: CreateJobPageThree(job: jobEntity),
      );
    },
  ),

  GoRoute(
    path: RouteName.resumeDetail,
    name: RouteName.resumeDetail,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};

      return BlocProvider(
        create: (context) => sl<ResumeBloc>(),
        child: EmpResumeScreenDetail(userId: extra['userId'] as String),
      );
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
        fromJobCreation: extra['fromJobCreation'] as bool? ?? false,
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

  GoRoute(
    path: RouteName.empSupportDetail,
    name: RouteName.empSupportDetail,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpSupportDetailScreen();
    },
  ),
];
