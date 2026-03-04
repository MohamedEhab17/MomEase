import 'package:injectable/injectable.dart';
import 'package:record/record.dart';

@module
abstract class AppModule {
  @lazySingleton
  AudioRecorder get audioRecorder => AudioRecorder();
}
