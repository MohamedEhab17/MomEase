import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/children/data/datasources/children_remote_data_source.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@LazySingleton(as: ChildrenRepository)
class ChildrenRepositoryImpl implements ChildrenRepository {
  final ChildrenRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  ChildrenRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<Child>>> getChildren() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final children = await _remote.getChildren();
      return Right(children);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Child>> getChild(int childId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final child = await _remote.getChild(childId);
      return Right(child);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Child>> createChild(CreateChildParams params) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final child = await _remote.createChild(params);
      return Right(child);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Child>> updateChild(
    int childId,
    UpdateChildParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final child = await _remote.updateChild(childId, params);
      return Right(child);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> deleteChild(int childId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.deleteChild(childId);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(int childId, File photo) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final url = await _remote.uploadPhoto(childId, photo);
      return Right(url);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> deletePhoto(int childId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.deletePhoto(childId);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
