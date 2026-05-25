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
            debugPrint('[GenUiResponseParser] Parsed component: id="$id" type="$typeName"');
          } catch (e) {
            debugPrint('[GenUiResponseParser] Skipped malformed component "$id" ($typeName): $e');
          }
        }
      } else if (name == 'beginRendering') {
        final rootId =
            (call.arguments['rootComponentId'] as String?)?.trim() ?? '';
        if (rootId.isNotEmpty) {
          rootComponentId = rootId;
          debugPrint('[GenUiResponseParser] Root component: "$rootComponentId"');
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
    debugPrint('[GenUiResponseParser] Created SurfaceUpdate with ${validComponents.length} components.');

    if (rootComponentId != null) {
      messages.add(BeginRendering(surfaceId: surfaceId, root: rootComponentId));
      debugPrint('[GenUiResponseParser] Rendering started for root "$rootComponentId".');
    }

    return messages;
  }
}
