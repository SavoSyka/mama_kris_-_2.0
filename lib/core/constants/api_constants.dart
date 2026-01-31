class ApiConstants {
  ApiConstants._();

  // auth
  static const forceUpdate = 'client-version/check';

  static const login = 'auth/login';

  static const checkEmail = 'auth/check-email';
  static const forgotPassword = 'auth/reset-password-email';
  static const updatePassword = 'auth/change-password';

  static const validateCode = 'auth/verify-code';
  static const resendOtp = 'auth/check-email';

  static const register = 'auth/register';
  static const changePassword = 'auth/change-password';

  // jobs

  static String getJobs(String userID) => "jobs/search-combined/$userID";

  static String getRandomJobs(String userID) =>
      'jobs/search-by-profile/$userID';
  static String likeOrDislikeJob(String userID, String jobID) =>
      '/viewed-jobs/$userID/$jobID';
  static String getLikedJobs(String userID) => '/viewed-jobs/liked-ids/$userID';
  static String getViewedJobsCount(String userID) => '/viewed-jobs/viewed-count/$userID';

  static String getUserProfile(String userID) => '/users/$userID';

  static String searchJobs(String query) => 'jobs/autocomplete?query=$query';
  static const getAllSphereVacancies = 'jobs/autocomplete?query=';
  static String userPreference(String? userId) => '/user-preferences/$userId';
  static const searchCombined = 'jobs/search-combined';
  static String createJob(String? userId) => 'jobs/user/$userId';
  static String getUserJob(String? userId) => 'jobs/user/$userId';
  static String updateContacts(String? userId, String? contactId) =>
      'contacts/$userId/$contactId';
  static const getProfessions = 'professions';
  static const getContacts = 'contacts';

  // users
  static const getUsers = "users/search/profiles";

  static const getTariffs = "tariffs";

  static String createContact(String userId) => "contacts/$userId";
  static String updateContact(String userId, String contactId) =>
      "contacts/$userId/$contactId";
  static String deleteContact(String userId, String contactId) =>
      "contacts/$userId/$contactId";

  static String updateUser(String userId) => "users/$userId/update-info";

  static String deleteUserAcct(String userId) => "users/$userId";
  static String loginWIthGoogle = "auth/google/login";
  static String loginWithApple = "auth/apple/login";

  static String getSpeciality = 'jobs/autocomplete';

  static const favoriteProfiles = "favorite-profiles";
  static String addUsersToFavorite(String userId) =>
      "favorite-profiles/$userId";

  static String generatePaymentLink(String userId) =>
      "payments.v3/generate-link/$userId";

  static String getPublicProfile(String userId) => "users/public/$userId";

  // ads
  static const getAds = 'advertisements/next';
  
  // analytics
  static const getPublicCounts = 'analytics/public-counts';
  static String addToHide(String userId) => "hidden-profiles/$userId";
  static String removeFromHide(String userId) => "hidden-profiles/$userId";
  static const getHiddenUsers = "hidden-profiles";
  static String getUserFromCached(String userId) => "users/$userId";

  static String userEnterSession(String userId) => "session-times/user/$userId";
  static String userLeftSession(String userId, String sessionId) =>
      "session-times/user/$userId/session/$sessionId";

  // email subscription
  static String subscribeEmail(String userID) =>
      '/mail/confirm-subscription/$userID';
  static const unsubscribeEmail = 'email-subscription/unsubscribe';
}
