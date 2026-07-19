import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import '../../../models/chatbot_response_model.dart';

/// Strict, resilient parser that converts a [UiPayloadModel] into a sequence
/// of [A2uiMessage] events (SurfaceUpdate then BeginRendering).
///
/// Resilience guarantees:
/// - Each component is individually validated before parsing.
/// - Invalid or malformed components are skipped with a debug log.
/// - The pipeline never crashes on a bad component.
/// - [firstOrNull] / unsafe extension calls are never used.
abstract class GenUiResponseParser {
  /// Parses [uiPayload] and returns an ordered list of [A2uiMessage].
  /// Returns an empty list on validation failure; never throws.
  static List<A2uiMessage> parse(UiPayloadModel uiPayload, String surfaceId) {
    final List<A2uiMessage> messages = [];

    debugPrint('[GENUI] Parsing started');
    
    // Detailed Raw JSON encoding log as requested
    try {
      final List<Map<String, dynamic>> rawCalls = uiPayload.calls.map((call) => {
        'name': call.name,
        'arguments': call.arguments,
      }).toList();
      debugPrint('[GENUI RAW PAYLOAD] ${jsonEncode({'calls': rawCalls})}');
    } catch (e) {
      debugPrint('[GENUI RAW PAYLOAD ENCODE ERROR] $e');
    }

    if (uiPayload.calls.isEmpty) {
      debugPrint('[GenUiResponseParser] UI payload has no calls — skipping.');
      return messages;
    }

    final List<Component> validComponents = [];
    String? rootComponentId;

    for (final call in uiPayload.calls) {
      final name = call.name.trim();
      if (name.isEmpty) {
        debugPrint('[GenUiResponseParser] Ignored call with empty name.');
        continue;
      }

      if (name == 'surfaceUpdate') {
        final componentsRaw =
            call.arguments['components'] as List<dynamic>? ?? const [];

        if (componentsRaw.isEmpty) {
          debugPrint('[GenUiResponseParser] surfaceUpdate has no components.');
          continue;
        }

        debugPrint('[GenUiResponseParser] Components count: ${componentsRaw.length}');

        for (final raw in componentsRaw) {
          // ── strict validation ─────────────────────────────────────────────
          if (raw is! Map<String, dynamic>) {
            debugPrint('[GenUiResponseParser] Skipped invalid component: not a JSON object.');
            continue;
          }

          if (!raw.containsKey('id') || raw['id'] is! String) {
            debugPrint('[GenUiResponseParser] Skipped invalid component: missing/bad "id".');
            continue;
          }

          final id = (raw['id'] as String).trim();
          if (id.isEmpty) {
            debugPrint('[GenUiResponseParser] Skipped invalid component: empty "id".');
            continue;
          }

          if (!raw.containsKey('component') ||
              raw['component'] is! Map<String, dynamic>) {
            debugPrint('[GenUiResponseParser] Skipped component "$id": missing/bad "component" map.');
            continue;
          }

          final componentMap = raw['component'] as Map<String, dynamic>;

          // Safely read the type name without using firstOrNull
          final String typeName = componentMap.keys.isNotEmpty
              ? componentMap.keys.first
              : 'Unknown';

          try {
            final component = Component.fromJson(raw);
            validComponents.add(component);
            debugPrint('[GENUI COMPONENT] Parsed: $id type="$typeName"');
          } catch (e, stackTrace) {
            // Full stacktrace logging on component parsing failure
            debugPrint('[GENUI COMPONENT PARSING FAILURE] Skipped component "$id" ($typeName): $e');
            debugPrint(stackTrace.toString());
          }
        }
      } else if (name == 'beginRendering') {
        final rootId =
            (call.arguments['rootComponentId'] as String?)?.trim() ?? '';
        if (rootId.isNotEmpty) {
          rootComponentId = rootId;
          debugPrint('[GENUI ROOT] $rootComponentId');
        } else {
          debugPrint('[GenUiResponseParser] beginRendering: missing rootComponentId.');
        }
      } else {
        debugPrint('[GenUiResponseParser] Ignored unrecognised call: "$name"');
      }
    }

    if (validComponents.isEmpty) {
      debugPrint('[GenUiResponseParser] No valid components — skipping SurfaceUpdate.');
      return messages;
    }

    messages.add(SurfaceUpdate(surfaceId: surfaceId, components: validComponents));
    debugPrint('[GENUI FLOW] SurfaceUpdate emitted with ${validComponents.length} components');

    if (rootComponentId != null) {
      messages.add(BeginRendering(
        surfaceId: surfaceId,
        root: rootComponentId,
        catalogId: 'newmama.com:postpartum_chat_v1',
      ));
      debugPrint('[GENUI FLOW] BeginRendering emitted for root "$rootComponentId"');
    }

    return messages;
  }
}
