import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> getCachedUser();

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int age,
  });

  Future<Either<Failure, String>> verifyEmail({
    required String email,
    required String otpCode,
  });

  Future<Either<Failure, String>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  });

  Future<Either<Failure, String>> resendOtp({
    required String email,
  });

  Future<Either<Failure, User>> googleLogin({
    required String idToken,
  });

  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<Either<Failure, String>> revokeToken({
    required String refreshToken,
  });
}
