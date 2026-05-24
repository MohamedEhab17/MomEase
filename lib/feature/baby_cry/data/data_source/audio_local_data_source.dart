abstract class AudioLocalDataSource {
  Future<bool> hasPermission();
  Future<String> startRecording(String path);
  Future<String?> stopRecording();
}
