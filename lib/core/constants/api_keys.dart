class Api {
  static const String baseUrl = 'http://momease.runasp.net/api/';

  // Auth endpoints
  static const String login = 'Auth/login';
  static const String register = 'Auth/register';
  static const String verifyEmail = 'Auth/verify-email';
  static const String refreshToken = 'Auth/refresh-token';
  static const String forgotPassword = 'Auth/forgot-password';
  static const String resetPassword = 'Auth/reset-password';
  static const String resendOtp = 'Auth/resend-otp';
  static const String googleLogin = 'Auth/google-login';
  static const String changePassword = 'Auth/change-password';
  static const String revokeToken = 'Auth/revoke-token';
  static const String logout = 'Auth/logout';

  // Depression endpoints
  static const String getAssessments = 'assessments';
  static const String getQuestions = 'assessments/{assessmentId}/questions';
  static const String submitAssessment = 'assessments/{assessmentId}/submit';
  static const String getQuestionById =
      'assessments/{assessmentId}/questions/{questionId}';
  static const String getOptionsByQuestionId = 'questions/{questionId}/options';
  static const String getAssessmentResult = "assessment-results/{id}";

  /// Children (Baby) endpoints.
  static const String children = 'Children';
  static String childById(int id) => 'Children/$id';
  static String childPhoto(int id) => 'Children/$id/photo';

  /// Articles endpoints.
  static const String articleCategories = 'articles/categories';
  static const String articles = 'Articles/category/{categoryId}';
  static const String articleDetail = 'Articles/{id}';
  static const String articleSearch = 'Articles/search';
  static const String savedArticles = 'saved-articles';
  static String deleteSavedArticle(int id) => 'saved-articles/$id';

  // Search History endpoints
  static const String searchHistory = 'search/history';
  static String deleteSearchTerm(String term) => 'search/history/$term';
  
}
