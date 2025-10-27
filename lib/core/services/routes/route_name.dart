class RouteName {
  RouteName._();

  static String initialPage = "/initial-page";

  // static String authPage = '/auth-page';
  /// * APPLICANT ROUTES
  static const String _applicant = '/auth/appl';

  ///
  static String loginApplicant = '/$_applicant/login';
  static String signupApplicant = '/$_applicant/signup';
  static String forgotApplicant = '/$_applicant/forgot';

  static String homeApplicant = '/$_applicant/home';
  static String supportDetailApplicant = '/$_applicant/support-detail';
  static String editProfileApplicant = '/$_applicant/edit-profile';

  // * EMPLOYE ROUTES
  static const String _employee = '/auth/emp';
  static String loginEmploye = '/$_employee/login';
  static String signupEmploye = '/$_employee/signup';
  static String homeEmploye = '/$_employee/home';
  static String createJobPageOne = '/$_employee/create/1';

  static String createJobPageTwo = '/$_employee/create/2';
  static String createJobPageThree = '/$_employee/create/3';
  static String resumeDetail = "/$_employee/resume-detail";




  static String welcomePage = "/getStart";
  static String forceUpdate = "/force-update";

  static String welcomeApplicant = "/welcome-applicant";
  static String welcomeEmploye = "/welcome-employe";

  static String employesHome = "/employes-home";
  static String postJob = "/post-job";
  static String applicantHome = "/applicant-home";

  static String login = "/login";
  static String welcomeSignup = "/welcome-signup";

  static String signupName = "/signup-name";
  static String signupGender = "/signup-gender";
  static String signupBirthDate = "/signup-birth-date";

  static String findMyAcct = "/find-my-account";
  static String checkEmail = "/check-email";
  static String signupMobilePhone = "/signup-mobile-phone";

  static String notificationList = "/notifications";
  static String notificationDetail = "/notification-detail";
}
