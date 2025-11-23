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
  static String updateApplicantPwd = '/$_applicant/update-pwd';
  static String changeApplicantPwd = '/$_applicant/change-pwd';

  static String verifyOptApplicant = '/$_applicant/verify';

  static String homeApplicant = '/$_applicant/home';
  static String supportDetailApplicant = '/$_applicant/support-detail';
  static String editProfileApplicant = '/$_applicant/edit-profile';

  static String editProfileBasicInfoApplicant = '/$_applicant/edit-basic-info';
  static String editProfileContactInfoApplicant =
      '/$_applicant/edit-contact-info';
  static String editProfileworkExpereinceInfoApplicant =
      '/$_applicant/edit-work-expereince';
  static String editProfileEducationInfoApplicant =
      '/$_applicant/edit-education-info';

  static String supportDetail = '/$_applicant/support-detail';

  // * EMPLOYE ROUTES
  static const String _employee = '/auth/emp';
  static String loginEmploye = '/$_employee/login';
  static String signupEmploye = '/$_employee/signup';
  static String verifyOtpEmployee = '/$_employee/verify';
  static String forgotEmployee = '/$_employee/forgot';

  static String updateEmployeePwd = '/$_employee/update-pwd';
  static String changeEmployeePwd = '/$_employee/change-pwd';

  static String homeEmploye = '/$_employee/home';
  static String createJobPageOne = '/$_employee/create/1';

  static String createJobPageTwo = '/$_employee/create/2';
  static String createJobPageThree = '/$_employee/create/3';
  static String resumeDetail = "/$_employee/resume-detail";

  static String editProfileEmployee = '/$_employee/edit-profile';

  static String editProfileBasicInfoEmployee = '/$_employee/edit-basic-info';
  static String editProfileContactInfoEmployee =
      '/$_employee/edit-contact-info';
  static String editProfileworkExpereinceInfoEmployee =
      '/$_employee/edit-work-expereince';
  static String editProfileEducationInfoEmployee =
      '/$_employee/edit-education-info';

  static String welcomePage = "/getStart";
  static String forceUpdate = "/force-update";

  static String subscription = "/subscription";
  static String paymentWebView = "/payment-web-view";

  static String paymentCheckingPage = "/payment-checking-page";

  static String welcomeApplicant = "/welcome-applicant";
  static String welcomeEmploye = "/welcome-employe";

  static String postJob = "/post-job";

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
