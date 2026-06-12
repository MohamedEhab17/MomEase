import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../datasources/chatbot_remote_data_source.dart';

/// Repository interface for chatbot feature
/// Follows repository pattern for clean architecture
abstract class ChatbotRepository {
  /// Sends a user message to the AI
  Future<void> sendMessage(String message);

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

/// Implementation of ChatbotRepository
class ChatbotRepositoryImpl implements ChatbotRepository {
  ChatbotRepositoryImpl(this._remoteDataSource);

  final ChatbotRemoteDataSource _remoteDataSource;

  @override
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }
    await _remoteDataSource.sendMessage(UserMessage.text(message.trim()));
  }

  @override
  Stream<A2uiMessage> get a2uiMessageStream =>
      _remoteDataSource.a2uiMessageStream;

  @override
  Stream<String> get textResponseStream => _remoteDataSource.textResponseStream;

  @override
  Stream<ContentGeneratorError> get errorStream =>
      _remoteDataSource.errorStream;

  @override
  ValueListenable<bool> get isProcessing => _remoteDataSource.isProcessing;

  @override
  ValueListenable<List<ChatMessage>> get conversation =>
      _remoteDataSource.conversation;

  @override
  void dispose() {
    _remoteDataSource.dispose();
  }

  @override
  A2uiMessageProcessor get a2uiMessageProcessor =>
      _remoteDataSource.a2uiMessageProcessor;
}
