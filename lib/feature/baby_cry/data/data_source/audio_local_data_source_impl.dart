import 'package:injectable/injectable.dart';
import 'package:record/record.dart';
import 'audio_local_data_source.dart';

@LazySingleton(as: AudioLocalDataSource)
class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final AudioRecorder _recorder;

  AudioLocalDataSourceImpl(this._recorder);

  @override
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  @override
  Future<String> startRecording(String path) async {
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: path,
    );
    return path;
  }

  @override
  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }
}
