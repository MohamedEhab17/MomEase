import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';

/// A custom [ContentGenerator] that routes chatbot queries
/// to the custom backend endpoint instead of calling Gemini directly.
class BackendContentGenerator implements ContentGenerator {
  BackendContentGenerator() {
    _apiClient = getIt<ApiClient>();
    _localDataSource = getIt<AuthLocalDataSource>();
  }

  late final ApiClient _apiClient;
  late final AuthLocalDataSource _localDataSource;

  final _a2uiMessageController = StreamController<A2uiMessage>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  final _textResponseController = StreamController<String>.broadcast();
  final _isProcessing = ValueNotifier<bool>(false);

  @override
  Stream<A2uiMessage> get a2uiMessageStream => _a2uiMessageController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  Stream<String> get textResponseStream => _textResponseController.stream;

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    A2UiClientCapabilities? clientCapabilities,
    Iterable<ChatMessage>? history,
  }) async {
    _isProcessing.value = true;

    try {
      // 1. Retrieve the currently logged in user's ID
      final user = await _localDataSource.getUser();
      final userId = user?.userId ?? 51; // Default fallback to 51

      // 2. Extract message text content from the ChatMessage parts safely
      String text = '';
      final msg = message;
      if (msg is UserMessage) {
        text = msg.parts.whereType<TextPart>().map((part) => part.text).join('\n');
      } else if (msg is AiTextMessage) {
        text = msg.parts.whereType<TextPart>().map((part) => part.text).join('\n');
      } else {
        text = msg.toString();
      }

      // 3. Make HTTP POST call to the backend chatbot endpoint
      final response = await _apiClient.post(
        'ChatBot/send',
        data: {
          'userId': userId,
          'message': text,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data as Map<String, dynamic>;
        final success = body['success'] == true;
        
        if (success && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          final reply = data['reply'] as String;

          // 4. Emit the reply text. GenUiConversation automatically listens to this
          // stream and handles parsing GenUI codeblocks or standard text.
          _textResponseController.add(reply);
        } else {
          final errorMessage = body['message'] as String? ?? 'Failed to get response';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Server responded with status code ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      final error = ContentGeneratorError(
        e.toString(),
        stackTrace,
      );
      _errorController.add(error);
      rethrow;
    } finally {
      _isProcessing.value = false;
    }
  }

  @override
  void dispose() {
    _a2uiMessageController.close();
    _errorController.close();
    _textResponseController.close();
    _isProcessing.dispose();
  }
}
