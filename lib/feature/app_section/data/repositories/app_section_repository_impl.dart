import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_remote_datasource_contract.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';

@LazySingleton(as: AppSectionRepositoryContract)
class AppSectionRepositoryImpl implements AppSectionRepositoryContract {
  final AppSectionRemoteDatasourceContract _remoteDatasource;
  AppSectionRepositoryImpl(this._remoteDatasource);
  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {

try {
      await _remoteDatasource.logout(refreshToken);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
