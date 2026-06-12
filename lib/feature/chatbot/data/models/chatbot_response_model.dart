class ChatbotResponseModel {
  final bool success;
  final String? message;
  final ChatbotDataModel? data;

  const ChatbotResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatbotResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? ChatbotDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChatbotDataModel {
  final String? replyText;
  final UiPayloadModel? uiPayload;

  const ChatbotDataModel({
    this.replyText,
    this.uiPayload,
  });

  factory ChatbotDataModel.fromJson(Map<String, dynamic> json) {
    return ChatbotDataModel(
      replyText: (json['reply'] as String?) ?? (json['text'] as String?) ?? (json['replyText'] as String?),
      uiPayload: json['ui'] != null
          ? UiPayloadModel.fromJson(json['ui'] as Map<String, dynamic>)
          : json['uiPayload'] != null
              ? UiPayloadModel.fromJson(json['uiPayload'] as Map<String, dynamic>)
              : null,
    );
  }
}

class UiPayloadModel {
  final List<UiCallModel> calls;

  const UiPayloadModel({
    required this.calls,
  });

  factory UiPayloadModel.fromJson(Map<String, dynamic> json) {
    final callsList = json['calls'] as List<dynamic>? ?? const [];
    return UiPayloadModel(
      calls: callsList
          .whereType<Map<String, dynamic>>()
          .map((callJson) => UiCallModel.fromJson(callJson))
          .toList(),
    );
  }
}

class UiCallModel {
  final String name;
  final Map<String, dynamic> arguments;

  const UiCallModel({
    required this.name,
    required this.arguments,
  });

  factory UiCallModel.fromJson(Map<String, dynamic> json) {
    return UiCallModel(
      name: json['name'] as String? ?? '',
      arguments: json['arguments'] as Map<String, dynamic>? ?? const {},
    );
  }
}
