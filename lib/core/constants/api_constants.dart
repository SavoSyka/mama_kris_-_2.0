class ApiConstants {
  ApiConstants._();

  static const forceUpdate = 'client-version/1';

  static const login = 'auth/login';
  static const checkEmail = 'auth/check-email';
  static const forgotPassword = 'auth/reset-password-email';

  static const validateCode = 'auth/verify-code';
  static const register = 'auth/register';
  static const changePassword = 'auth/change-password';
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
}
