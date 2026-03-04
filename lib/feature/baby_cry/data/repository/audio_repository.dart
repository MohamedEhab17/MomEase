import 'package:dartz/dartz.dart';
import 'failure.dart';

abstract class AudioRepository {
  Future<Either<Failure, String>> startRecording();
  Future<Either<Failure, String?>> stopRecording();
}
