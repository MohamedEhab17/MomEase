class Api {
  static const String baseUrl = 'http://momease.runasp.net/api/';

  /// Relative to [baseUrl] (already ends with `api/`).
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
  static const String getAssessments = 'assessments';
  static const String getQuestions = 'assessments/{assessmentId}/questions';
  static const String submitAssessment = 'assessments/{assessmentId}/submit';
  static const String getQuestionById = 'assessments/{assessmentId}/questions/{questionId}';
  static const String getOptionsByQuestionId = 'questions/{questionId}/options';
  static const String getAssessmentResult = "assessment-results/{id}";
}

