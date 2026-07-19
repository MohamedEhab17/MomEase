import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';
import 'package:new_mama/feature/notifications/domain/repository/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._remote, this._networkInfo);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final notifications = await _remote.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final count = await _remote.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> markNotificationRead(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.markNotificationRead(id);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> markAllNotificationsRead() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.markAllNotificationsRead();
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> deleteNotification(int id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.deleteNotification(id);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> registerDeviceToken(String token) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.registerDeviceToken(token);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> removeDeviceToken(String token) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final msg = await _remote.removeDeviceToken(token);
      return Right(msg);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
