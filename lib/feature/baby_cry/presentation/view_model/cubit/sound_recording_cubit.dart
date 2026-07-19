import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/audio_repository.dart';

import 'package:new_mama/core/base/safe_cubit.dart';

part 'sound_recording_state.dart';

@injectable
class SoundRecordingCubit extends SafeCubit<SoundRecordingState> {
  final AudioRepository _audioRepository;
  Timer? _timer;
  int _seconds = 0;

  SoundRecordingCubit(this._audioRepository) : super(SoundRecordingInitial());

  Future<void> startRecording() async {
    safeEmit(RecordingStarted());

    final result = await _audioRepository.startRecording();
    
    result.fold(
      (failure) => safeEmit(RecordingError(failure.message)),
      (path) {
        _seconds = 0;

        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (_) {
            _seconds++;
            safeEmit(RecordingInProgress(_seconds));
          },
        );
      },
    );
  }

  Future<void> stopRecording() async {
    final result = await _audioRepository.stopRecording();
    
    result.fold(
      (failure) => safeEmit(RecordingError(failure.message)),
      (path) {
        if (path != null && File(path).existsSync()) {
          log("Recording exists ✅: $path");
        } else {
          log("Recording failed ❌");
        }

        _timer?.cancel();
        safeEmit(RecordingStopped(path));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
