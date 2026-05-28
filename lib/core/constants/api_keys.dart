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

  /// Depression endpoints
  static const String getAssessments = 'assessments';
  static const String getQuestions = 'assessments/{assessmentId}/questions';
  static const String submitAssessment = 'assessments/{assessmentId}/submit';
  static const String getQuestionById =
      'assessments/{assessmentId}/questions/{questionId}';
  static const String getOptionsByQuestionId = 'questions/{questionId}/options';
  static const String getAssessmentResult = "assessment-results/{id}";
  static const String assessmentResultsHistory = 'assessment-results';
  static String deleteAssessmentResult(int id) => 'assessment-results/$id';

  /// Children (Baby) endpoints.
  static const String children = 'Children';
  static String childById(int id) => 'Children/$id';
  static String childPhoto(int id) => 'Children/$id/photo';
  static String childVaccinations(int childId) => 'children/$childId/vaccinations';
  static String childVaccinationById(int childId, int id) => 'children/$childId/vaccinations/$id';
  static String childUpcomingVaccinations(int childId) => 'children/$childId/vaccinations/upcoming';
  static String childOverdueVaccinations(int childId) => 'children/$childId/vaccinations/overdue';
  static String childCompletedVaccinations(int childId) => 'children/$childId/vaccinations/completed';
  static String markVaccinationTaken(int childId, int id) => 'children/$childId/vaccinations/$id/mark-taken';
  static String childSleepRecords(int childId) => 'children/$childId/sleep-records';
  static String childSleepRecordsWeekly(int childId) => 'children/$childId/sleep-records/weekly';
  static String childSleepRecordsMonthly(int childId) => 'children/$childId/sleep-records/monthly';
  static String childSleepRecordsStatistics(int childId) => 'children/$childId/sleep-records/statistics';
  static String childFeedingRecords(int childId) => 'children/$childId/feeding-records';
  static String childFeedingRecordsWeekly(int childId) => 'children/$childId/feeding-records/weekly';
  static String childFeedingRecordsMonthly(int childId) => 'children/$childId/feeding-records/monthly';
  static String childFeedingRecordsStatistics(int childId) => 'children/$childId/feeding-records/statistics';

  /// Articles endpoints.
  static const String articleCategories = 'articles/categories';
  static const String articles = 'Articles/category/{categoryId}';
  static const String articleDetail = 'Articles/{id}';
  static const String articleSearch = 'Articles/search';
  static const String savedArticles = 'saved-articles';
  static String deleteSavedArticle(int id) => 'saved-articles/$id';

  /// Search History endpoints
  static const String searchHistory = 'search/history';
  static String deleteSearchTerm(String term) => 'search/history/$term';

  /// Skin Analysis endpoints.
  static const String skinAnalyze = 'skin-analysis/analyze';
  static const String skinUserAnalyses = 'skin-analysis/user';
  static String skinChildAnalyses(int childId) =>
      'skin-analysis/child/$childId';
  static String skinAnalysisById(int id) => 'skin-analysis/$id';

  // Community endpoints
  static const String communityPosts = 'community/posts';
  static String communityPostById(int id) => 'community/posts/$id';
  static const String myPosts = 'community/posts/my-posts';
  static String toggleSavePost(int id) => 'community/posts/$id/save';
  static const String savedPosts = 'community/saved-posts';
  static String reportPost(int id) => 'community/posts/$id/reports';
  static String postReactions(int id) => 'community/posts/$id/reactions';
  // Comment endpoints
  static String postComments(int postId) => 'community/posts/$postId/comments';
  static String postCommentById(int postId, int commentId) => 'community/posts/$postId/comments/$commentId';
  static String commentReactions(int postId, int commentId) => 'community/posts/$postId/comments/$commentId/reactions';
  // Reply endpoints
  static String commentReplies(int postId, int commentId) => 'community/posts/$postId/comments/$commentId/replies';
  static String replyById(int postId, int commentId, int replyId) => 'community/posts/$postId/comments/$commentId/replies/$replyId';

  /// AppSection endpoints
  static const String getUser = 'Users/profile';
  static const String updateProfile = 'Users/profile';
  static const String changeUserPassword = 'Users/change-password';

  /// profile endpoints
  static const String motherProfile  = 'MotherProfile'; 
}
