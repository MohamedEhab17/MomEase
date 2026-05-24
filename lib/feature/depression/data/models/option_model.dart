import 'package:new_mama/feature/depression/domain/entities/option.dart';

class OptionModel extends Option {
  const OptionModel({
    required super.id,
    required super.questionId,
    required super.text,
    super.textAr,
    required super.score,
    required super.optionOrder,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['optionId'] is int ? json['optionId'] : int.tryParse(json['optionId']?.toString() ?? '') ?? 0,
      questionId: json['questionId'] is int ? json['questionId'] : int.tryParse(json['questionId']?.toString() ?? '') ?? 0,
      text: json['optionText']?.toString() ?? json['text']?.toString() ?? '',
      textAr: json['optionTextAr']?.toString() ?? json['textAr']?.toString(),
      score: json['score'] is int ? json['score'] : int.tryParse(json['score']?.toString() ?? '') ?? 0,
      optionOrder: json['optionOrder'] is int ? json['optionOrder'] : int.tryParse(json['optionOrder']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': id,
      'questionId': questionId,
      'optionText': text,
      'optionTextAr': textAr,
      'score': score,
      'optionOrder': optionOrder,
    };
  }

  Option toEntity() {
    return Option(
      id: id,
      questionId: questionId,
      text: text,
      textAr: textAr,
      score: score,
      optionOrder: optionOrder,
    );
  }
}
