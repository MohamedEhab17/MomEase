import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../data_source/audio_local_data_source.dart';
import 'audio_repository.dart';
import 'package:new_mama/core/error/failure.dart';

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final AudioLocalDataSource _audioLocalDataSource;

  AudioRepositoryImpl(this._audioLocalDataSource);

  @override
  Future<Either<Failure, String>> startRecording() async {
    try {
      final hasPermission = await _audioLocalDataSource.hasPermission();
      if (!hasPermission) {
        return Left(const PermissionFailure());
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

      final path = await _audioLocalDataSource.startRecording(filePath);
      return Right(path);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> stopRecording() async {
    try {
      final path = await _audioLocalDataSource.stopRecording();
      return Right(path);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
