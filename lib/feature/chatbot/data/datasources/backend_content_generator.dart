import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';

import '../models/chatbot_response_model.dart';
import '../catalog/catalog_items/shared/genui_response_parser.dart';
import '../catalog/catalog_items/shared/fallback_ui_factory.dart';
import 'message_extractor.dart';

// ─── UUID Generator ──────────────────────────────────────────────────────────

/// Cryptographically-secure RFC 4122 v4 UUID generator.
class UuidGenerator {
  static String generateV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    // Set version 4
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    // Set RFC 4122 variant
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) buffer.write('-');
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}

// ─── BackendContentGenerator ─────────────────────────────────────────────────

/// A lightweight, strictly-typed [ContentGenerator] that routes chatbot queries
/// to the postpartum backend.
///
/// ### Key guarantees
/// - **Message Queue**: All inbound responses are enqueued and dispatched
///   sequentially to avoid interleaved renders.
/// - **Race condition fix**: A 40 ms gap is inserted between [SurfaceUpdate]
///   and [BeginRendering] so the renderer has time to register the components.
/// - **Deduplication**: A SHA-256-free, simple content hash guards against
///   re-rendering identical payloads within a session.
/// - **Text suppression**: The text stream is suppressed when a valid UI
///   payload is rendered.
/// - **Error recovery UI**: Network / parsing errors yield a graceful fallback
///   card instead of crashing the chat.
class BackendContentGenerator implements ContentGenerator {
  BackendContentGenerator() {
    _apiClient = getIt<ApiClient>();
    _localDataSource = getIt<AuthLocalDataSource>();
  }

  late final ApiClient _apiClient;
  late final AuthLocalDataSource _localDataSource;

  // ── Streams ──────────────────────────────────────────────────────────────
  final _a2uiController = StreamController<A2uiMessage>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  final _textController = StreamController<String>.broadcast();
  final _isProcessing = ValueNotifier<bool>(false);

  // ── Message queue ─────────────────────────────────────────────────────────
  /// FIFO queue of [A2uiMessage] batches waiting for emission.
  final Queue<List<A2uiMessage>> _messageQueue = Queue();
  bool _isDispatching = false;

  // ── Deduplication ─────────────────────────────────────────────────────────
  /// Stores lightweight hashes of already-rendered payloads.
  final Set<int> _renderedPayloadHashes = {};

  // ── Session ───────────────────────────────────────────────────────────────
  String? _conversationId;

  // ── ContentGenerator contract ─────────────────────────────────────────────
  @override
  Stream<A2uiMessage> get a2uiMessageStream => _a2uiController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  Stream<String> get textResponseStream => _textController.stream;

  // ── Public sendRequest ────────────────────────────────────────────────────

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    A2UiClientCapabilities? clientCapabilities,
    Iterable<ChatMessage>? history,
  }) async {
    _isProcessing.value = true;

    try {
      // 1. User identity
      final user = await _localDataSource.getUser();
      final int userId = user?.userId ?? 51;

      // 2. Extract text safely
      final String text = MessageExtractor.extract(message);

      // 3. Locale detection
      final String rawLocale = PlatformDispatcher.instance.locale.languageCode;
      final String locale = rawLocale == 'ar' ? 'ar' : 'en';

      // 4. Session management – regenerate if new conversation
      if (history == null || history.isEmpty || _conversationId == null) {
        _conversationId = UuidGenerator.generateV4();
        debugPrint('[Chatbot Session] New session: $_conversationId');
      }

      // 5. Build request payload with enhanced prompt to instruct LLM dynamically
      final String enhancedPrompt = _buildEnhancedPrompt(text);

      final Map<String, dynamic> payload = {
        'userId': userId,
        'message': enhancedPrompt,
        'conversationId': _conversationId,
        'language': locale,
      };

      debugPrint(
        '[Chatbot Network] Sending request — userId=$userId locale=$locale session=$_conversationId',
      );

      // 6. Single-retry boundary
      final dynamic response = await _fetchWithRetry(payload);

      // 7. Parse response
      if (response.statusCode == 200 && response.data != null) {
        debugPrint('[GENUI FLOW] Response received');

        ChatbotResponseModel model;
        try {
          model = ChatbotResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        } catch (e, stackTrace) {
          debugPrint('[Chatbot Network] Malformed or truncated JSON structure in response: $e');
          debugPrint(stackTrace.toString());
          _emitErrorRecoveryUi('Invalid response structure from server.');
          return;
        }

        if (model.success && model.data != null) {
          await _processSuccessResponse(
            model.data!,
            locale: locale,
            text: text,
          );
        } else {
          final msg = model.message ?? 'Server failed to process request.';
          _emitErrorRecoveryUi(msg, locale: locale);
        }
      } else {
        _emitErrorRecoveryUi(
          'Server responded with status ${response.statusCode}.',
          locale: locale,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[Chatbot Network] Unhandled error: $e');
      _emitErrorRecoveryUi(e.toString());
      _errorController.add(ContentGeneratorError(e.toString(), stackTrace));
      rethrow;
    } finally {
      _isProcessing.value = false;
    }
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  /// One-retry boundary for transient network failures.
  Future<dynamic> _fetchWithRetry(Map<String, dynamic> payload) async {
    try {
      return await _apiClient.post('ChatBot/send', data: payload);
    } catch (e) {
      debugPrint('[Chatbot Network] Transient failure. Retrying once...');
      try {
        final result = await _apiClient.post('ChatBot/send', data: payload);
        debugPrint('[Chatbot Network] Retry succeeded.');
        return result;
      } catch (retryError) {
        debugPrint('[Chatbot Network] Retry failed.');
        rethrow;
      }
    }
  }

  /// Processes a successful [ChatbotDataModel].
  Future<void> _processSuccessResponse(
    ChatbotDataModel data, {
    required String locale,
    required String text,
  }) async {
    final String replyText = data.replyText ?? '';
    final UiPayloadModel? uiPayload = data.uiPayload;

    final bool hasUiPayload = uiPayload != null && uiPayload.calls.isNotEmpty;
    List<A2uiMessage> msgs = [];

    // Generate a unique surfaceId for this response sequence to isolate scroll history
    final String responseSurfaceId = 'chatbot_${UuidGenerator.generateV4()}';

    if (hasUiPayload) {
      debugPrint('[Chatbot Processing] UI payload detected.');
      final int payloadHash = _hashPayload(uiPayload.calls);

      if (!_renderedPayloadHashes.contains(payloadHash)) {
        _renderedPayloadHashes.add(payloadHash);
        msgs = GenUiResponseParser.parse(uiPayload, responseSurfaceId);
      } else {
        debugPrint('[Chatbot Processing] Duplicate payload hash — skipping render.');
      }
    }

    if (msgs.isNotEmpty) {
      // Emit UI
      debugPrint('[GENUI FLOW] Parsing successful');
      debugPrint('[Chatbot Processing] Emitting GenUI payload.');
      _enqueue(msgs);

      // Render the clean text bubble alongside the UI widgets if present
      if (replyText.isNotEmpty) {
        final String cleanedReplyText = FallbackUiFactory.cleanText(replyText);
        if (cleanedReplyText.isNotEmpty) {
          _textController.add(cleanedReplyText);
        }
      }
    } else {
      // Emit Text only (and its fallback dynamic suggestions)
      if (replyText.isNotEmpty) {
        debugPrint('[Chatbot Processing] Emitting Text and dynamic suggestions.');

        // 1. Detect if the text contains embedded JSON components (e.g. from a simple backend)
        final List<A2uiMessage> embeddedFallback = FallbackUiFactory.parseTextComponents(
          text: replyText,
          language: locale,
          surfaceId: responseSurfaceId,
        );

        if (embeddedFallback.isNotEmpty) {
          debugPrint('[Chatbot Processing] Dynamic embedded JSON components detected.');
          
          // Clean the raw JSON blocks from the response text
          final String cleanedJsonReply = FallbackUiFactory.cleanJsonCallsFromText(replyText);
          final String cleanedText = FallbackUiFactory.cleanText(cleanedJsonReply);

          _enqueue(embeddedFallback);
          
          if (cleanedText.isNotEmpty) {
            _textController.add(cleanedText);
          }
        } else {
          // Standard text and suggestions flow
          // 1. Dynamic intent detection
          final String? detectedIntent = FallbackUiFactory.detectIntent(text, replyText);

          // 2. Extract suggestions from response text if present
          final List<String> parsedSuggestions = FallbackUiFactory.extractSuggestions(replyText);

          // 3. Clean the response text from the suggestions block to avoid duplication
          final String cleanedReplyText = FallbackUiFactory.cleanText(replyText);

          final List<A2uiMessage> fallback = FallbackUiFactory.create(
            text: cleanedReplyText,
            language: locale,
            intent: detectedIntent,
            surfaceId: responseSurfaceId,
            showCard: false, // Do not show duplicate pink card for normal text replies
            customSuggestions: parsedSuggestions.isNotEmpty ? parsedSuggestions : null,
          );

          if (fallback.isNotEmpty) {
            _enqueue(fallback);
          }

          // Emit the clean text bubble
          _textController.add(cleanedReplyText);
        }
      }
    }
  }

  /// Emits an error-recovery UI (InformationCard + Trailhead) instead of crashing.
  void _emitErrorRecoveryUi(String reason, {String locale = 'en'}) {
    debugPrint(
      '[Chatbot Error Recovery] Emitting recovery UI. reason="$reason"',
    );
    final bool isArabic = locale == 'ar';
    final String body = isArabic
        ? 'عذراً، حدث خطأ مؤقت. يرجى المحاولة مرة أخرى. 🙏'
        : 'Apologies, a temporary error occurred. Please try again. 🙏';

    final List<A2uiMessage> recovery = FallbackUiFactory.create(
      text: body,
      language: locale,
      surfaceId: 'chatbot',
      showCard: true, // For error recovery, we DO want to show a standalone card!
    );

    if (recovery.isNotEmpty) {
      _enqueue(recovery);
    }
  }

  // ── Message Queue ─────────────────────────────────────────────────────────

  /// Adds a batch of messages to the queue and starts dispatch if idle.
  void _enqueue(List<A2uiMessage> messages) {
    _messageQueue.addLast(messages);
    if (!_isDispatching) _dispatchNext();
  }

  /// Sequentially dispatches queued message batches with the race-condition guard.
  Future<void> _dispatchNext() async {
    if (_messageQueue.isEmpty) {
      _isDispatching = false;
      return;
    }

    _isDispatching = true;
    final List<A2uiMessage> batch = _messageQueue.removeFirst();

    for (int i = 0; i < batch.length; i++) {
      final msg = batch[i];
      _a2uiController.add(msg);
      if (msg is SurfaceUpdate) {
        debugPrint('[GENUI FLOW] SurfaceUpdate emitted with ${msg.components.length} components');
      } else if (msg is BeginRendering) {
        debugPrint('[GENUI FLOW] BeginRendering emitted for root "${msg.root}"');
      } else {
        debugPrint('[Chatbot Queue] Dispatched: ${msg.runtimeType}');
      }

      // ── Race condition fix ───────────────────────────────────────────────
      // Insert a 40 ms gap between SurfaceUpdate and BeginRendering so the
      // GenUI renderer has time to register components before rendering starts.
      if (msg is SurfaceUpdate &&
          i + 1 < batch.length &&
          batch[i + 1] is BeginRendering) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    // Process the next batch
    _dispatchNext();
  }

  // ── Payload hashing ───────────────────────────────────────────────────────

  /// Produces a lightweight collision-resistant hash for a list of UI calls.
  int _hashPayload(List<UiCallModel> calls) {
    final StringBuffer sb = StringBuffer();
    for (final call in calls) {
      sb.write(call.name);
      sb.write(jsonEncode(call.arguments));
    }
    return sb.toString().hashCode;
  }

  // ── Dispose ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _a2uiController.close();
    _errorController.close();
    _textController.close();
    _isProcessing.dispose();
    _messageQueue.clear();
  }

  /// Appends formatting schemas and guidelines to instruct the AI dynamically
  String _buildEnhancedPrompt(String userPrompt) {
    return '''
$userPrompt

[Instruct:Luna AI. Scope: postpartum mom & baby care only. Refuse off-topic politely (e.g. "أنا هنا لمساعدتكِ في شؤون الأمومة ورعاية طفلكِ فقط. 😊"). Do not pretend to book appointments.
Reply text or JSON 'uiPayload' (use diverse components):
- `InformationCard`: {"name":"InformationCard","arguments":{"title":{"literalString":"T"},"body":{"literalString":"B"}}} (advice)
- `Trailhead`: {"name":"Trailhead","arguments":{"topics":[{"literalString":"O"}],"action":{"name":"select_topic","context":[]}}} (chips)
- `MoodCheckCard`: {"name":"MoodCheckCard","arguments":{"title":{"literalString":"T"}}} (mood logs)
- `InsightCard`: {"name":"InsightCard","arguments":{"title":{"literalString":"T"},"message":{"literalString":"M"},"type":"info/warning/success"}} (tips)
- `ActivityTimeline`: {"name":"ActivityTimeline","arguments":{"title":{"literalString":"T"},"activities":[{"time":{"literalString":"H"},"type":{"literalString":"A"}}]}} (routines)
- `AnalysisResultCard`: {"name":"AnalysisResultCard","arguments":{"title":{"literalString":"T"},"result":{"literalString":"R"},"confidence":90}} (symptoms)
- `ActionCard`: {"name":"ActionCard","arguments":{"title":{"literalString":"T"},"icon":"mic/camera/upload","action":{"name":"A","context":[]}}} (actions)
- `AskForSupportAction`: {"name":"AskForSupportAction","arguments":{"title":{"literalString":"T"},"action":{"name":"A"}}} (doctor)
Rules:
- Warnings: `InsightCard`.
- Routines: `ActivityTimeline`.
- Symptoms: `AnalysisResultCard`+`ActionCard`.
- Doctor: `AskForSupportAction`.
- Options: `Trailhead`.
- Reply warmly in user's language.]
''';
  }
}
