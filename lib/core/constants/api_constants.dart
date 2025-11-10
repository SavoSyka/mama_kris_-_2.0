class ApiConstants {
  ApiConstants._();

  // auth
  static const forceUpdate = 'client-version/1';

  static const login = 'auth/login';

  static const checkEmail = 'auth/check-email';
  static const forgotPassword = 'auth/reset-password-email';

  static const validateCode = 'auth/verify-code';
  static const register = 'auth/register';
  static const changePassword = 'auth/change-password';

  // jobs

  static getJobs(String userID) => "jobs/search-combined/$userID";

  static getRandomJobs(String userID) => 'jobs/search-by-profile/$userID';
  static likeOrDislikeJob(String userID, String jobID) =>
      '/viewed-jobs/$userID/$jobID';
  static getLikedJobs(String userID) => '/viewed-jobs/liked-ids/$userID';

  static getUserProfile(String userID) => '/users/$userID';

  static searchJobs(String query) => 'jobs/autocomplete?query=$query';
  static const getAllSphereVacancies = 'jobs/autocomplete?query=';
  static userPreference(String? userId) => '/user-preferences/$userId';
  static const searchCombined = 'jobs/search-combined';
  static createJob(String? userId) => 'jobs/user/$userId';
  static getUserJob(String? userId) => 'jobs/user/$userId';
  static updateContacts(String? userId, String? contactId) =>
      'contacts/$userId/$contactId';
  static const getProfessions = 'professions';
  static const getContacts = 'contacts';

  // users
  static getUsers(String userID) => "users/search/$userID";

  static const getTariffs = "tariffs";

}
