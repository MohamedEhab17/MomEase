import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source_contract.dart';
import '../datasources/auth_remote_data_source_contract.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      if (userModel != null) {
        return Right(userModel);
      } else {
        return const Left(CacheFailure('No user cached'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(
          email: email,
          password: password,
        );

        if (response.success && response.data != null) {
          final user = response.data?.user;
          final tokens = response.data?.tokens;

          try {
            if (user != null) {
              await _localDataSource.saveUser(user);
            }
            if (tokens != null) {
              await _localDataSource.saveTokens(tokens);
            }
          } catch (e) {
            return Left(CacheFailure('Failed to save session: ${e.toString()}'));
          }

          if (user != null) {
            return Right(user);
          } else {
            return const Left(ServerFailure('User data missing from response.'));
          }
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      final user = await _localDataSource.getUser();
      if (user != null) {
        return Right(user);
      }
      return const Left(ServerFailure('No internet connection and no cached data found.'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int age,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          phone: phone,
          age: age,
        );

        if (response.success && response.data != null) {
          final user = response.data?.user;
          final tokens = response.data?.tokens;

          if (user != null) {
            await _localDataSource.saveUser(user);
          }
          if (tokens != null) {
            await _localDataSource.saveTokens(tokens);
          }
          // Mark email as pending verification so the router can redirect back
          // to the OTP screen if the user restarts before verifying.
          await _localDataSource.savePendingVerificationEmail(email);

          if (user != null) {
            return Right(user);
          } else {
            return const Left(ServerFailure('User data missing from response.'));
          }
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail({
    required String email,
    required String otpCode,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.verifyEmail(
          email: email,
          otpCode: otpCode,
        );

        if (response.success) {
          // Email verified — remove the pending flag
          await _localDataSource.clearPendingVerificationEmail();

          final tokens = response.data?.tokens;
          final user = response.data?.user;

          if (tokens != null) {
            await _localDataSource.saveTokens(tokens);
          } else {
            // Proactively refresh tokens to get a fresh token with confirmed claims
            final currentTokens = await _localDataSource.getTokens();
            if (currentTokens != null && currentTokens.refreshToken.isNotEmpty) {
              try {
                final refreshResponse = await _remoteDataSource.refreshToken(
                  refreshToken: currentTokens.refreshToken,
                );
                if (refreshResponse.success && refreshResponse.data?.tokens != null) {
                  await _localDataSource.saveTokens(refreshResponse.data!.tokens!);
                }
              } catch (_) {
                // Ignore silent refresh errors here
              }
            }
          }

          if (user != null) {
            await _localDataSource.saveUser(user);
          }

          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  // Response: { success, message, data: { resetToken: "3601" } }
  // We return the resetToken so the UI can pass it to reset-password if needed
  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.forgotPassword(email: email);
        if (response.success) {
          // Return the resetToken from data if present, otherwise the message
          final resetToken = response.data?.resetToken;
          return Right(resetToken ?? response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  // Response: { success, message } — no data
  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.resetPassword(
          email: email,
          otpCode: otpCode,
          newPassword: newPassword,
        );
        if (response.success) {
          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  // Response: { success, message } — OTP for email verification
  @override
  Future<Either<Failure, String>> resendOtp({
    required String email,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.resendOtp(email: email);
        if (response.success) {
          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, User>> googleLogin({
    required String idToken,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.googleLogin(idToken: idToken);
        if (response.success && response.data != null) {
          final user = response.data?.user;
          final tokens = response.data?.tokens;

          if (user != null) {
            await _localDataSource.saveUser(user);
          }
          if (tokens != null) {
            await _localDataSource.saveTokens(tokens);
          }

          if (user != null) {
            return Right(user);
          } else {
            return const Left(ServerFailure('User data missing from response.'));
          }
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmNewPassword: confirmNewPassword,
        );
        if (response.success) {
          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  // Response: { success, message } — clears local storage on success
  @override
  Future<Either<Failure, String>> revokeToken({
    required String refreshToken,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.revokeToken(refreshToken: refreshToken);
        if (response.success) {
          await _localDataSource.clearAll();
          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }
}
