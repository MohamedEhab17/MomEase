import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../datasource/notification_local_datasource.dart';
import '../model/notification_model.dart';
import 'notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _localDataSource;
  
  List<NotificationModel> _cachedNotifications = [];

  NotificationRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({bool refresh = false, required int limit}) async {
    try {
      if (!refresh && _cachedNotifications.isNotEmpty) {
        return Right(_cachedNotifications);
      }
      final notifications = await _localDataSource.getNotifications(limit: limit);
      _cachedNotifications = List.from(notifications);
      return Right(_cachedNotifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> loadMoreNotifications({required int limit}) async {
    try {
      final startIndex = _cachedNotifications.length;
      final newNotifications = await _localDataSource.getNotifications(limit: limit, startIndex: startIndex);
      _cachedNotifications.addAll(newNotifications);
      return Right(_cachedNotifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int index) async {
    try {
      if (index >= 0 && index < _cachedNotifications.length) {
        final notif = _cachedNotifications[index];
        if (notif.isUnread) {
          _cachedNotifications[index] = notif.copyWith(isUnread: false);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(int index) async {
    try {
      if (index >= 0 && index < _cachedNotifications.length) {
        _cachedNotifications.removeAt(index);
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      _cachedNotifications.clear();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
