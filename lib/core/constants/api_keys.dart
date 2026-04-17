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
}
