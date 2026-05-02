import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';

abstract class AppSectionRemoteDatasourceContract {
    Future<Either<Failure, void>> logout(String refreshToken);
}