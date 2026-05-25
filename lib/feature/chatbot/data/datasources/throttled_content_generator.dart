import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../constants/chatbot_config.dart';

/// A [ContentGenerator] that throttles requests and prevents duplicates.
/// Helps prevent rate limiting and improves user experience.
class ThrottledContentGenerator implements ContentGenerator {
  /// Creates a [ThrottledContentGenerator] that wraps the [delegate].
  ThrottledContentGenerator(
    this.delegate, {
    this.throttleDuration = ChatbotConfig.throttleDuration,
  });

  /// The delegate [ContentGenerator].
  final ContentGenerator delegate;

  /// The minimum duration between requests.
  final Duration throttleDuration;

  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
  bool _isRequesting = false;
  String _lastNormalizedText = '';

  @override
  void dispose() => delegate.dispose();

  @override
  Stream<A2uiMessage> get a2uiMessageStream => delegate.a2uiMessageStream;

  @override
  Stream<ContentGeneratorError> get errorStream => delegate.errorStream;

  @override
  ValueListenable<bool> get isProcessing => delegate.isProcessing;

  @override
  Stream<String> get textResponseStream => delegate.textResponseStream;

  String _normalizeMessage(ChatMessage message) {
    if (message is UserMessage) {
      final text = message.parts
          .whereType<TextPart>()
          .map((part) => part.text)
          .join('\n');
      return text.trim().toLowerCase();
    } else if (message is UserUiInteractionMessage) {
      return message.text.trim().toLowerCase();
    }
    return message.toString().trim().toLowerCase();
  }

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    A2UiClientCapabilities? clientCapabilities,
    Iterable<ChatMessage>? history,
  }) async {
    final String normalized = _normalizeMessage(message);
    final DateTime now = DateTime.now();

    // 1. Check Throttling
    if (now.difference(_lastRequestTime) < throttleDuration) {
      throw Exception('Please wait a moment before sending another message.');
    }

    // 2. Check De-duplication (In-flight) with 10-second guard
    // If the EXACT same normalized message is sent while another is processing,
    // and less than 10 seconds has passed since the last request, treat it as a duplicate.
    final bool isDuplicate = _isRequesting &&
        normalized == _lastNormalizedText &&
        now.difference(_lastRequestTime) < const Duration(seconds: 10);

    if (isDuplicate) {
      throw Exception('Request is already in progress.');
    }

    _isRequesting = true;
    _lastNormalizedText = normalized;
    _lastRequestTime = now;

    try {
      await delegate
          .sendRequest(
            message,
            clientCapabilities: clientCapabilities,
            history: history,
          )
          .timeout(ChatbotConfig.requestTimeout);
    } on TimeoutException catch (_) {
      // Handle timeout first before other errors
      throw Exception(
        'The AI is taking too long to respond. '
        'Please try again in a moment.',
      );
    } catch (e) {
      // Handle Rate Limits / Quota
      final String errorFn = e.toString().toLowerCase();
      if (errorFn.contains('429') ||
          errorFn.contains('quota') ||
          errorFn.contains('resource has been exhausted')) {
        throw Exception(
          'API quota limit reached. '
          'Please wait a minute and try again.',
        );
      }
      rethrow;
    } finally {
      // Re-enable after response/error
      _isRequesting = false;
    }
  }
}
