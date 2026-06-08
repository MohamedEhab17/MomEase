import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

/// FallbackUiFactory dynamically generates a GenUI widget tree when the backend
/// returns a plain-text response (no structured UI payload).
/// Intent detection is applied so the fallback UI matches the user's query domain.
/// Supported intents: feeding, sleep, mood, fatigue, emotional, emergency, recovery.
abstract class FallbackUiFactory {
  static List<A2uiMessage> create({
    required String text,
    required String language,
    String? intent,
    required String surfaceId,
    bool showCard = false,
    List<String>? customSuggestions,
  }) {
    debugPrint(
      '[FallbackUiFactory] Creating fallback. language="$language" intent="${intent ?? 'generic'}" showCard=$showCard suggestionsCount=${customSuggestions?.length ?? 0}',
    );

    final bool isArabic = language == 'ar';
    final String titleText = tr(TK.chatbotGuidanceTitle);

    List<Map<String, dynamic>> topics;
    if (customSuggestions != null && customSuggestions.isNotEmpty) {
      topics = customSuggestions.map((s) => {"literalString": s}).toList();
    } else {
      topics = _topicsFor(intent, isArabic: isArabic);
    }

    List<Component> components;

    try {
      components = _buildComponents(
        titleText: titleText,
        bodyText: text,
        topics: topics,
        showCard: showCard,
      );
    } catch (e) {
      debugPrint('[FallbackUiFactory] Failed to build components: $e');
      return [];
    }

    return [
      SurfaceUpdate(surfaceId: surfaceId, components: components),
      BeginRendering(
        surfaceId: surfaceId,
        root: 'root_fallback_column',
        catalogId: 'newmama.com:postpartum_chat_v1',
      ),
    ];
  }

  //  Embedded JSON Components Parser 

  /// Parses raw JSON components embedded directly inside plain-text lines
  static List<A2uiMessage> parseTextComponents({
    required String text,
    required String language,
    required String surfaceId,
  }) {
    final List<String> lines = text.split('\n');
    final List<Map<String, dynamic>> parsedCalls = [];
    bool hasMoodCheckCard = false;

    // 1. Decode and analyze calls from lines
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map<String, dynamic> && decoded.containsKey('name')) {
            final String name = decoded['name'] as String? ?? '';
            final Map<String, dynamic> arguments = decoded['arguments'] as Map<String, dynamic>? ?? const {};
            if (name.isNotEmpty) {
              parsedCalls.add({
                'name': name,
                'arguments': arguments,
              });
              if (name == 'MoodCheckCard') {
                hasMoodCheckCard = true;
              }
            }
          }
        } catch (_) {
          // Ignore invalid JSON lines
        }
      }
    }

    // 2. Strip redundant Trailhead chips if an interactive MoodCheckCard is present
    if (hasMoodCheckCard) {
      parsedCalls.removeWhere((call) => call['name'] == 'Trailhead');
    }

    if (parsedCalls.isEmpty) return const [];

    final List<Component> components = [];
    final List<String> childIds = [];

    // 3. Construct GenUI Component objects
    for (int i = 0; i < parsedCalls.length; i++) {
      final call = parsedCalls[i];
      final String name = call['name'] as String;
      final Map<String, dynamic> arguments = call['arguments'] as Map<String, dynamic>;
      final String id = 'injected_${name.toLowerCase()}_$i';

      components.add(Component.fromJson({
        'id': id,
        'component': {
          name: arguments
        }
      }));
      childIds.add(id);
    }

    debugPrint('[FallbackUiFactory] Parsed ${components.length} embedded JSON components from text.');

    // Inject Column layout wrapping all discovered components
    components.insert(0, Component.fromJson({
      'id': 'injected_root_column',
      'component': {
        'Column': {
          'children': {
            'explicitList': childIds,
          }
        }
      }
    }));

    return [
      SurfaceUpdate(surfaceId: surfaceId, components: components),
      BeginRendering(
        surfaceId: surfaceId,
        root: 'injected_root_column',
        catalogId: 'newmama.com:postpartum_chat_v1',
      ),
    ];
  }

  /// Strips raw embedded JSON component lines from the response text
  static String cleanJsonCallsFromText(String text) {
    final List<String> lines = text.split('\n');
    final List<String> cleanLines = [];

    for (final line in lines) {
      final trimmed = line.trim();
      bool isJsonCall = false;
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map<String, dynamic> && decoded.containsKey('name')) {
            isJsonCall = true;
          }
        } catch (_) {}
      }

      if (!isJsonCall) {
        cleanLines.add(line);
      }
    }
    return cleanLines.join('\n').trim();
  }

  //  Intent detection & suggestions extractor 

  /// Dynamically determines intent based on both the user query and AI response
  static String? detectIntent(String query, String response) {
    final combined = '$query $response'.toLowerCase();

    // 1. Emergency
    if (combined.contains('طوارئ') ||
        combined.contains('طوارى') ||
        combined.contains('خطر') ||
        combined.contains('نزيف') ||
        combined.contains('ألم شديد') ||
        combined.contains('الم شديد') ||
        combined.contains('حرارة مرتفعة') ||
        combined.contains('سخونية') ||
        combined.contains('مستشفى') ||
        combined.contains('emergency') ||
        combined.contains('danger') ||
        combined.contains('bleeding') ||
        combined.contains('severe pain') ||
        combined.contains('fever') ||
        combined.contains('hospital') ||
        combined.contains('doctor')) {
      return 'emergency';
    }

    // 2. Feeding
    if (combined.contains('تغذية') ||
        combined.contains('تغذيه') ||
        combined.contains('رضاعة') ||
        combined.contains('رضاعه') ||
        combined.contains('حليب') ||
        combined.contains('جوع') ||
        combined.contains('أكل') ||
        combined.contains('اكل') ||
        combined.contains('طعام') ||
        combined.contains('فطام') ||
        combined.contains('ثدي') ||
        combined.contains('feeding') ||
        combined.contains('breastfeed') ||
        combined.contains('milk') ||
        combined.contains('lactation') ||
        combined.contains('food') ||
        combined.contains('eat') ||
        combined.contains('hungry')) {
      return 'feeding';
    }

    // 3. Sleep
    if (combined.contains('نوم') ||
        combined.contains('ينام') ||
        combined.contains('أرق') ||
        combined.contains('ارق') ||
        combined.contains('سهر') ||
        combined.contains('استيقاظ') ||
        combined.contains('صعوبة النوم') ||
        combined.contains('sleep') ||
        combined.contains('wake') ||
        combined.contains('bedtime') ||
        combined.contains('nap') ||
        combined.contains('insomnia')) {
      return 'sleep';
    }

    // 4. Recovery
    if (combined.contains('تعافي') ||
        combined.contains('التئام') ||
        combined.contains('جرح') ||
        combined.contains('ولادة قيصرية') ||
        combined.contains('قيصري') ||
        combined.contains('خياطة') ||
        combined.contains('خياطه') ||
        combined.contains('نفاس') ||
        combined.contains('postpartum') ||
        combined.contains('recovery') ||
        combined.contains('c-section') ||
        combined.contains('wound') ||
        combined.contains('healing')) {
      return 'recovery';
    }

    // 5. Mood / Emotional
    if (combined.contains('مزاج') ||
        combined.contains('تعب') ||
        combined.contains('إرهاق') ||
        combined.contains('ارهاق') ||
        combined.contains('حزين') ||
        combined.contains('حزن') ||
        combined.contains('قلق') ||
        combined.contains('توتر') ||
        combined.contains('اكتئاب') ||
        combined.contains('نفسية') ||
        combined.contains('نفسيه') ||
        combined.contains('مخنوق') ||
        combined.contains('ضيق') ||
        combined.contains('صداع') ||
        combined.contains('mood') ||
        combined.contains('sad') ||
        combined.contains('tired') ||
        combined.contains('exhausted') ||
        combined.contains('depressed') ||
        combined.contains('anxiety') ||
        combined.contains('stress') ||
        combined.contains('fatigue') ||
        combined.contains('emotional')) {
      return 'mood';
    }

    return null; // default
  }

  /// Extracts suggestions from the AI's response text dynamically
  static List<String> extractSuggestions(String text) {
    final List<String> suggestions = [];
    final List<String> lines = text.split('\n');

    final List<String> suggestionHeaders = [
      'الاقتراحات:',
      'أسئلة مقترحة:',
      'يمكنك الاستفسار عن:',
      'أسئلة قد تهمك:',
      'اقتراحات القراءة:',
      'يمكنك سؤالي عن:',
      'suggestions:',
      'suggested questions:',
      'suggested topics:',
      'follow-up:',
      'inquire about:'
    ];

    int headerIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim().toLowerCase();
      for (final header in suggestionHeaders) {
        if (line.contains(header)) {
          headerIndex = i;
          break;
        }
      }
      if (headerIndex != -1) break;
    }

    if (headerIndex != -1) {
      for (int i = headerIndex + 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final bulletMatch = RegExp(r'^[\-\*\•\d+\.\s\u2022]+(.*)$').firstMatch(line);
        if (bulletMatch != null) {
          final content = bulletMatch.group(1)?.trim() ?? '';
          if (content.isNotEmpty) {
            suggestions.add(content);
          }
        } else {
          if (line.length < 50) {
            suggestions.add(line);
          }
        }
      }
    } else {
      int bulletStartIdx = -1;
      for (int i = lines.length - 1; i >= 0; i--) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        final isBullet = RegExp(r'^[\-\*\•\d+\.\s\u2022]+(.*)$').hasMatch(line);
        if (isBullet) {
          bulletStartIdx = i;
        } else {
          break;
        }
      }

      if (bulletStartIdx != -1 && lines.length - bulletStartIdx <= 6) {
        for (int i = bulletStartIdx; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.isEmpty) continue;
          final bulletMatch = RegExp(r'^[\-\*\•\d+\.\s\u2022]+(.*)$').firstMatch(line);
          if (bulletMatch != null) {
            final content = bulletMatch.group(1)?.trim() ?? '';
            if (content.isNotEmpty) {
              suggestions.add(content);
            }
          }
        }
      }
    }

    final uniqueSuggestions = suggestions
        .map((s) => _cleanSuggestion(s))
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    if (uniqueSuggestions.length > 5) {
      return uniqueSuggestions.sublist(0, 5);
    }
    return uniqueSuggestions;
  }

  static String _cleanSuggestion(String text) {
    String s = text.trim();
    if (s.startsWith('[') && s.endsWith(']')) {
      s = s.substring(1, s.length - 1).trim();
    }
    if (s.startsWith('"') && s.endsWith('"')) {
      s = s.substring(1, s.length - 1).trim();
    }
    if (s.startsWith("'") && s.endsWith("'")) {
      s = s.substring(1, s.length - 1).trim();
    }
    while (s.endsWith('.') || s.endsWith('؟') || s.endsWith('?')) {
      s = s.substring(0, s.length - 1).trim();
    }
    return s;
  }

  /// Cleans the parsed suggestion block from the main message text
  static String cleanText(String text) {
    final List<String> lines = text.split('\n');

    final List<String> suggestionHeaders = [
      'الاقتراحات:',
      'أسئلة مقترحة:',
      'يمكنك الاستفسار عن:',
      'أسئلة قد تهمك:',
      'اقتراحات القراءة:',
      'يمكنك سؤالي عن:',
      'suggestions:',
      'suggested questions:',
      'suggested topics:',
      'follow-up:',
      'inquire about:'
    ];

    int headerIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim().toLowerCase();
      for (final header in suggestionHeaders) {
        if (line.contains(header)) {
          headerIndex = i;
          break;
        }
      }
      if (headerIndex != -1) break;
    }

    if (headerIndex != -1) {
      final cleanLines = lines.sublist(0, headerIndex);
      return cleanLines.join('\n').trim();
    }

    int bulletStartIdx = -1;
    for (int i = lines.length - 1; i >= 0; i--) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final isBullet = RegExp(r'^[\-\*\•\d+\.\s\u2022]+(.*)$').hasMatch(line);
      if (isBullet) {
        bulletStartIdx = i;
      } else {
        break;
      }
    }

    if (bulletStartIdx != -1 && lines.length - bulletStartIdx <= 6) {
      final cleanLines = lines.sublist(0, bulletStartIdx);
      return cleanLines.join('\n').trim();
    }

    return text.trim();
  }

  //  Topic resolution 

  static List<Map<String, dynamic>> _topicsFor(
    String? intent, {
    required bool isArabic,
  }) {
    switch (intent) {
      case 'feeding':
        return isArabic
            ? [
                {"literalString": "مواعيد الرضاعة 🍼"},
                {"literalString": "كمية الحليب المناسبة 🥛"},
                {"literalString": "طلب المساعدة 🩺"},
              ]
            : [
                {"literalString": "Feeding Schedule 🍼"},
                {"literalString": "Milk Amount 🥛"},
                {"literalString": "Ask Expert 🩺"},
              ];

      case 'sleep':
        return isArabic
            ? [
                {"literalString": "روتين نوم للرضيع 🌙"},
                {"literalString": "أسباب صعوبة النوم 😴"},
                {"literalString": "نصائح سريعة للراحة ✨"},
              ]
            : [
                {"literalString": "Baby Sleep Routine 🌙"},
                {"literalString": "Sleep Trouble Causes 😴"},
                {"literalString": "Quick Rest Tips ✨"},
              ];

      case 'mood':
      case 'fatigue':
      case 'emotional':
        return isArabic
            ? [
                {"literalString": "تمارين التنفس 🧘"},
                {"literalString": "فحص المزاج اليومي 💖"},
                {"literalString": "التحدث مع مرشدة 🌸"},
              ]
            : [
                {"literalString": "Breathing Exercises 🧘"},
                {"literalString": "Daily Mood Check 💖"},
                {"literalString": "Talk to Counselor 🌸"},
              ];

      case 'emergency':
        return isArabic
            ? [
                {"literalString": "اتصل بالطوارئ 📞"},
                {"literalString": "الأعراض الخطيرة 🚨"},
                {"literalString": "تواصل مع طبيبك 🩺"},
              ]
            : [
                {"literalString": "Call Emergency 📞"},
                {"literalString": "Danger Signs 🚨"},
                {"literalString": "Contact Your Doctor 🩺"},
              ];

      case 'recovery':
        return isArabic
            ? [
                {"literalString": "تعافي ما بعد الولادة 🌿"},
                {"literalString": "تمارين خفيفة للتعافي 💪"},
                {"literalString": "التغذية السليمة 🥗"},
              ]
            : [
                {"literalString": "Postpartum Recovery 🌿"},
                {"literalString": "Light Recovery Exercises 💪"},
                {"literalString": "Healthy Nutrition 🥗"},
              ];

      default:
        return isArabic
            ? [
                {"literalString": "تسجيل الرضاعة 🍼"},
                {"literalString": "فحص حالتي المزاجية 💖"},
                {"literalString": "نصائح النوم للرضيع 👶"},
                {"literalString": "استشارة طبية 🩺"},
              ]
            : [
                {"literalString": "Log Feeding 🍼"},
                {"literalString": "Check My Mood 💖"},
                {"literalString": "Baby Sleep Tips 👶"},
                {"literalString": "Medical Advice 🩺"},
              ];
    }
  }

  //  Component tree builder 

  static List<Component> _buildComponents({
    required String titleText,
    required String bodyText,
    required List<Map<String, dynamic>> topics,
    bool showCard = false,
  }) {
    return [
      // Root layout
      Component.fromJson({
        'id': 'root_fallback_column',
        'component': {
          'Column': {
            'children': {
              'explicitList': showCard
                  ? ['fallback_info_card', 'fallback_trailhead']
                  : ['fallback_trailhead'],
            },
          },
        },
      }),
      // Response card
      if (showCard)
        Component.fromJson({
          'id': 'fallback_info_card',
          'component': {
            'InformationCard': {
              'title': {'literalString': titleText},
              'body': {'literalString': bodyText},
            },
          },
        }),
      // Topic chooser
      Component.fromJson({
        'id': 'fallback_trailhead',
        'component': {
          'Topics': topics,
          'action': {'name': 'select_topic', 'context': []},
        },
      }),
    ];
  }
}
