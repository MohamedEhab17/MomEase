import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

/// FallbackUiFactory dynamically generates a GenUI widget tree when the backend
/// returns a plain-text response (no structured UI payload).
///
/// Intent detection is applied so the fallback UI matches the user's query domain.
/// Supported intents: feeding, sleep, mood, fatigue, emotional, emergency, recovery.
abstract class FallbackUiFactory {
  static List<A2uiMessage> create({
    required String text,
    required String language,
    String? intent,
    required String surfaceId,
  }) {
    debugPrint(
      '[FallbackUiFactory] Creating fallback. language="$language" intent="${intent ?? 'generic'}"',
    );

    final bool isArabic = language == 'ar';

    final String titleText = isArabic ? 'إرشاد أمومة ✨' : 'MomEase Care ✨';

    final List<Map<String, dynamic>> topics =
        _topicsFor(intent, isArabic: isArabic);

    List<Component> components;

    try {
      components = _buildComponents(titleText: titleText, bodyText: text, topics: topics);
    } catch (e) {
      debugPrint('[FallbackUiFactory] Failed to build components: $e');
      return [];
    }

    return [
      SurfaceUpdate(surfaceId: surfaceId, components: components),
      BeginRendering(surfaceId: surfaceId, root: 'root_fallback_column'),
    ];
  }

  // ── Topic resolution ──────────────────────────────────────────────────────

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
                {"literalString": "تمارين التنفس 🧘‍♀️"},
                {"literalString": "فحص المزاج اليومي 💖"},
                {"literalString": "التحدث مع مرشدة 🌸"},
              ]
            : [
                {"literalString": "Breathing Exercises 🧘‍♀️"},
                {"literalString": "Daily Mood Check 💖"},
                {"literalString": "Talk to Counselor 🌸"},
              ];

      case 'emergency':
        return isArabic
            ? [
                {"literalString": "اتصل بالطوارئ 📞"},
                {"literalString": "الأعراض الخطيرة ⚠️"},
                {"literalString": "تواصل مع طبيبك 🩺"},
              ]
            : [
                {"literalString": "Call Emergency 📞"},
                {"literalString": "Danger Signs ⚠️"},
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

  // ── Component tree builder ────────────────────────────────────────────────

  static List<Component> _buildComponents({
    required String titleText,
    required String bodyText,
    required List<Map<String, dynamic>> topics,
  }) {
    return [
      // Root layout
      Component.fromJson(const {
        'id': 'root_fallback_column',
        'component': {
          'Column': {
            'children': {
              'explicitList': ['fallback_info_card', 'fallback_trailhead'],
            },
          },
        },
      }),
      // Response card
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
          'Trailhead': {
            'topics': topics,
            'action': {'name': 'select_topic', 'context': []},
          },
        },
      }),
    ];
  }
}
