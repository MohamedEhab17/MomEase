import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../catalog/postpartum_catalog.dart';
import 'backend_content_generator.dart';
import 'throttled_content_generator.dart';

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

/// Implementation of ChatbotRemoteDataSource using custom postpartum backend endpoint
class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  ChatbotRemoteDataSourceImpl({String? apiKey, String? systemInstruction}) {
    final baseGenerator = BackendContentGenerator();
    _contentGenerator = ThrottledContentGenerator(baseGenerator);
    _uiConversation = GenUiConversation(
      a2uiMessageProcessor: A2uiMessageProcessor(
        catalogs: [postpartumChatCatalog],
      ),
      contentGenerator: _contentGenerator,
    );

    // Bulletproof manual binding layer & hard debug tracing
    _contentGenerator.a2uiMessageStream.listen((msg) {
      if (msg is SurfaceUpdate) {
        debugPrint('[GENUI FLOW] SurfaceUpdate received: ${msg.surfaceId} with ${msg.components.length} components');
      } else if (msg is BeginRendering) {
        debugPrint('[GENUI FLOW] BeginRendering received: ${msg.surfaceId}');
        final String surfaceId = msg.surfaceId;

        // Brief delay to allow the processor to fully handle BeginRendering first
        Future.delayed(const Duration(milliseconds: 10), () {
          final definition = _uiConversation.a2uiMessageProcessor
              .getSurfaceNotifier(surfaceId)
              .value;

          if (definition != null) {
            final conversationNotifier = _uiConversation.conversation as ValueNotifier<List<ChatMessage>>;
            final bool alreadyExists = conversationNotifier.value.any(
              (m) => m is AiUiMessage && m.surfaceId == surfaceId,
            );

            if (!alreadyExists) {
              debugPrint('[GENUI FLOW] Conversation injected: surfaceId=$surfaceId, root=${definition.rootComponentId}');
              conversationNotifier.value = [
                ...conversationNotifier.value,
                AiUiMessage(definition: definition, surfaceId: surfaceId),
              ];
            } else {
              debugPrint('[GENUI FLOW] AiUiMessage already present in conversation list.');
            }
          } else {
            debugPrint('[GENUI FLOW] WARNING: Definition is null for surfaceId=$surfaceId');
          }
        });
      }
    });
  }

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
    _contentGenerator.dispose();
  }

  @override
  A2uiMessageProcessor get a2uiMessageProcessor =>
      _uiConversation.a2uiMessageProcessor;
}
