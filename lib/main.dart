import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/lifecycle/bloc/life_cycle_manager_bloc.dart';
import 'package:mama_kris/core/services/lifecycle/lifecycle_manager.dart';
import 'package:mama_kris/core/services/routes/router.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/bloc/liked_job_bloc_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/ads_cubit.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/public_counts_bloc.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/features/email_subscription/application/bloc/email_subscription_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/create_job_cubit.dart';

import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/hide_resume_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_bloc.dart';
import 'package:mama_kris/features/emp/employe_contact/presentation/bloc/employee_contact_bloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/TarriffsBloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_payment_bloc.dart';
import 'package:mama_kris/features/subscription/application/cubit/subscription_status_cubit.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_bloc.dart';
import 'package:mama_kris/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ru_RU', null);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Force status bar icons to dark
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

    // debugPrint = (String? message, {int? wrapWidth}) => '';


  await dependencyInjection();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<EmpAuthBloc>()),
        BlocProvider(create: (_) => sl<ResumeBloc>()),
        BlocProvider(create: (_) => sl<JobBloc>()),
        BlocProvider(create: (_) => sl<LikedJobBlocBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => sl<ForceUpdateBloc>()),
        BlocProvider(create: (_) => sl<SubscriptionPaymentBloc>()),
        BlocProvider(create: (context) => sl<EmpUserBloc>()),
        BlocProvider(create: (context) => sl<CreateJobCubit>()),
        BlocProvider(create: (context) => sl<ApplicantContactBloc>()),
        BlocProvider(create: (context) => sl<EmployeeContactBloc>()),
        BlocProvider(create: (context) => sl<TarriffsBloc>()),
        BlocProvider.value(value: sl<AdsCubit>()),
        BlocProvider.value(value: sl<SpecialitySearchBloc>()),
        BlocProvider(create: (context) => sl<SubscriptionStatusCubit>()),
        BlocProvider(create: (context) => sl<HideResumeBloc>()),
        BlocProvider(create: (context) => sl<LifeCycleManagerBloc>()),
        BlocProvider(create: (context) => sl<EmailSubscriptionBloc>()),
        BlocProvider(create: (context) => sl<PublicCountsBloc>()),
      ],
      child:
       const MyApp(),
      // const SecurityGate(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return LifecycleManager(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: AppTheme.lightTheme,

            supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],

            localizationsDelegates: const [
              // Material localization
              GlobalMaterialLocalizations.delegate,

              // Widgets localization
              GlobalWidgetsLocalizations.delegate,

              // Cupertino localization (REQUIRED for CupertinoDatePicker)
              GlobalCupertinoLocalizations.delegate,
            ],

            locale: const Locale('ru', 'RU'),
            // home: const AppInitializer(),
          ),
        );
      },
    );
  }
}
