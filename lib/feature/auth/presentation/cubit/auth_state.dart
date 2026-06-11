import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Emitted after a successful **login** (or Google/biometric login).
/// LoginView listens to this to navigate into the app.
class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Emitted after a successful **registration**.
/// SignUpView listens to this to push to email verification.
/// LoginView deliberately ignores this state.
class RegisterSuccess extends AuthState {
  final User user;
  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class EmailVerificationSuccess extends AuthState {
  final String message;
  const EmailVerificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  /// The OTP/reset token returned by the API in data.resetToken
  final String resetToken;
  const ForgotPasswordSuccess({required this.message, required this.resetToken});

  @override
  List<Object?> get props => [message, resetToken];
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordSuccess extends AuthState {
  final String message;
  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendOtpSuccess extends AuthState {
  final String message;
  const ResendOtpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
