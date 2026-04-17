import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/auth/domain/usecases/change_password_use_case.dart';
import 'package:new_mama/core/base/usecase.dart';
import 'package:new_mama/feature/auth/domain/usecases/biometric_login_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/google_login_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/login_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/register_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/reset_password_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/revoke_token_use_case.dart';
import 'package:new_mama/feature/auth/domain/usecases/verify_email_use_case.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final RevokeTokenUseCase _revokeTokenUseCase;
  final BiometricLoginUseCase _biometricLoginUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._verifyEmailUseCase,
    this._forgotPasswordUseCase,
    this._resetPasswordUseCase,
    this._resendOtpUseCase,
    this._googleLoginUseCase,
    this._changePasswordUseCase,
    this._revokeTokenUseCase,
    this._biometricLoginUseCase,
  ) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> biometricLogin() async {
    emit(AuthLoading());
    final result = await _biometricLoginUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int age,
  }) async {
    emit(AuthLoading());
    final result = await _registerUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
      age: age,
    );
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> verifyEmail(String email, String otpCode) async {
    emit(AuthLoading());
    final result = await _verifyEmailUseCase(email: email, otpCode: otpCode);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (message) => emit(EmailVerificationSuccess(message)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await _forgotPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      // The repository returns the resetToken from data.resetToken
      // The UI can use this to pre-fill the OTP field on the reset-password screen
      (resetToken) => emit(ForgotPasswordSuccess(
        message: 'A password reset code has been sent to your email.',
        resetToken: resetToken,
      )),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(ResetPasswordParams(
      email: email,
      otpCode: otpCode,
      newPassword: newPassword,
    ));
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (message) => emit(ResetPasswordSuccess(message)),
    );
  }

  Future<void> resendOtp(String email) async {
    emit(AuthLoading());
    final result = await _resendOtpUseCase(email);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (message) => emit(ResendOtpSuccess(message)),
    );
  }

  Future<void> googleLogin(String idToken) async {
    emit(AuthLoading());
    final result = await _googleLoginUseCase(idToken);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(AuthLoading());
    final result = await _changePasswordUseCase(ChangePasswordParams(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    ));
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (message) => emit(ChangePasswordSuccess(message)),
    );
  }

  Future<void> logout(String refreshToken) async {
    emit(AuthLoading());
    final result = await _revokeTokenUseCase(refreshToken);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (message) => emit(AuthInitial()), // Return to initial state after logout
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
