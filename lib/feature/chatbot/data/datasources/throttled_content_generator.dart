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
  int _lastPromptHash = 0;

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

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    A2UiClientCapabilities? clientCapabilities,
    Iterable<ChatMessage>? history,
  }) async {
    // 1. Check Throttling
    final DateTime now = DateTime.now();
    if (now.difference(_lastRequestTime) < throttleDuration) {
      throw Exception('Please wait a moment before sending another message.');
    }

    // 2. Check De-duplication (In-flight)
    // We try to hash the content.
    final int promptHash = message.toString().hashCode;

    if (_isRequesting && promptHash == _lastPromptHash) {
      // Duplicate prompt in flight.
      throw Exception('Request is already in progress.');
    }

    _isRequesting = true;
    _lastPromptHash = promptHash;
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
