/// Configuration constants for the chatbot
class ChatbotConfig {
  /// Google Generative AI API Key
  static const String apiKey = 'AIzaSyBPk-cARwd0vbMo04el7vIeLrQBt9pAoso';

  /// Model name to use
  static const String modelName = 'models/gemini-2.5-flash-lite';

  /// Minimum time between requests (throttling)
  static const Duration throttleDuration = Duration(seconds: 1);

  /// Maximum time to wait for a response
  static const Duration requestTimeout = Duration(seconds: 120);
}
