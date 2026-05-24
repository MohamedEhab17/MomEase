import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';
import '../catalog/postpartum_catalog.dart';
import '../constants/chatbot_config.dart';
import '../constants/postpartum_care_prompt.dart';
import 'throttled_content_generator.dart';

/// Remote data source for chatbot functionality
/// Handles communication with the AI service
abstract class ChatbotRemoteDataSource {
  /// Sends a message to the AI and returns the response
  Future<void> sendMessage(ChatMessage message);

  /// Stream of AI messages
  Stream<A2uiMessage> get a2uiMessageStream;

  /// Stream of text responses
  Stream<String> get textResponseStream;

  /// Stream of errors
  Stream<ContentGeneratorError> get errorStream;

  /// Whether the AI is currently processing
  ValueListenable<bool> get isProcessing;

  /// Current conversation messages
  ValueListenable<List<ChatMessage>> get conversation;

  /// Disposes resources
  void dispose();

  /// A2uiMessageProcessor for rendering AI-generated UI (GenUiSurface)
  A2uiMessageProcessor get a2uiMessageProcessor;
}

/// Implementation of ChatbotRemoteDataSource using Google Generative AI
class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  ChatbotRemoteDataSourceImpl({String? apiKey, String? systemInstruction})
    : _apiKey = apiKey ?? ChatbotConfig.apiKey,
      _systemInstruction = systemInstruction ?? postpartumCareSystemPrompt {
    final baseGenerator = GoogleGenerativeAiContentGenerator(
      catalog: postpartumCareCatalog,
      systemInstruction: _systemInstruction,
      modelName: ChatbotConfig.modelName,
      apiKey: _apiKey,
    );
    _contentGenerator = ThrottledContentGenerator(baseGenerator);
    _uiConversation = GenUiConversation(
      a2uiMessageProcessor: A2uiMessageProcessor(
        catalogs: [postpartumCareCatalog],
      ),
      contentGenerator: _contentGenerator,
    );
  }

  final String _apiKey;
  final String _systemInstruction;

  late final ContentGenerator _contentGenerator;
  late final GenUiConversation _uiConversation;

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await _uiConversation.sendRequest(message);
  }

  @override
  Stream<A2uiMessage> get a2uiMessageStream =>
      _contentGenerator.a2uiMessageStream;

  @override
  Stream<String> get textResponseStream => _contentGenerator.textResponseStream;

  @override
  Stream<ContentGeneratorError> get errorStream =>
      _contentGenerator.errorStream;

  @override
  ValueListenable<bool> get isProcessing => _uiConversation.isProcessing;

  @override
  ValueListenable<List<ChatMessage>> get conversation =>
      _uiConversation.conversation;

  @override
  void dispose() {
    // We intentionally do not call _uiConversation.dispose() here.
    // _uiConversation contains the conversation and isProcessing ValueNotifiers.
    // During route transitions (e.g. popping the chatbot view), the widget tree's ValueListenableBuilders
    // are still active and will access these notifiers.
    // Disposing them here prematurely causes a FlutterError.
    // Leaving them to be naturally garbage collected by Dart is completely safe and leak-free.
    _contentGenerator.dispose();
  }

  @override
  A2uiMessageProcessor get a2uiMessageProcessor =>
      _uiConversation.a2uiMessageProcessor;
}
