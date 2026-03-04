part of 'sound_recording_cubit.dart';

@immutable
sealed class SoundRecordingState {}

final class SoundRecordingInitial extends SoundRecordingState {}

class RecordingStarted extends SoundRecordingState {}

class RecordingInProgress extends SoundRecordingState {
  final int seconds;
  RecordingInProgress(this.seconds);
}

class RecordingStopped extends SoundRecordingState {
  final String? path;
  RecordingStopped(this.path);
}

class RecordingError extends SoundRecordingState {
  final String message;
  RecordingError(this.message);
}
