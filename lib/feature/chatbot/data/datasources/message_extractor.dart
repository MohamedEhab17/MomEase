import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

/// Extracts a clean, user-readable text string from any [ChatMessage] subtype.
/// Handles UI interaction JSON payloads by pulling out topic, mood, or action name.
abstract class MessageExtractor {
  static String extract(ChatMessage message) {
    if (message is UserMessage) {
      return message.text.trim();
    }

    if (message is UserUiInteractionMessage) {
      return _extractFromUiInteraction(message.text);
    }

    if (message is AiTextMessage) {
      return message.text.trim();
    }

    return message.toString().trim();
  }

  static String _extractFromUiInteraction(String rawText) {
    try {
      final decoded = jsonDecode(rawText);
      if (decoded is Map<String, dynamic>) {
        final userAction = decoded['userAction'] as Map<String, dynamic>?;
        if (userAction != null) {
          final context = userAction['context'] as Map<String, dynamic>? ?? {};

          // Prefer topic, then mood, then action name
          final topic = context['topic'] as String?;
          if (topic != null && topic.isNotEmpty) return topic.trim();

          final mood = context['mood'] as String?;
          if (mood != null && mood.isNotEmpty) return mood.trim();

          final name = userAction['name'] as String?;
          if (name != null && name.isNotEmpty) return name.trim();
        }
      }
    } catch (e) {
      debugPrint('[MessageExtractor] Could not parse UI interaction JSON: $e');
    }
    // Return raw as last resort
    return rawText.trim();
  }
}
