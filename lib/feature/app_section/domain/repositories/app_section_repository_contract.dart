import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';

abstract class AppSectionRepositoryContract {
  Future<Either<Failure, void>> logout(String refreshToken);
}