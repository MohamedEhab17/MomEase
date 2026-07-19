import 'package:new_mama/feature/depression/data/models/option_model.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';


class QuestionModel extends Question {
  final List<OptionModel> optionsModel;

  const QuestionModel({
    required super.id,
    required super.text,
    required super.textAr,
    this.optionsModel = const [],
  }) : super(options: optionsModel);

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['questionId'] as int? ?? json['id'] as int? ?? 0,
      text: json['questionText'] as String? ?? json['text'] as String? ?? '',
      textAr: json['questionTextAr'] as String? ?? json['textAr'] as String? ?? '',
      optionsModel: (json['options'] as List?)
              ?.map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'textAr': textAr,
      'options': optionsModel.map((o) => o.toJson()).toList(),
    };
  }

  @override
  QuestionModel copyWith({
    int? id,
    String? text,
    String? textAr,
    List<Option>? options,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      textAr: textAr ?? this.textAr,
      optionsModel: options != null ? options.cast<OptionModel>() : optionsModel,
    );
  }


  Question toEntity() {
    return Question(
      id: id,
      text: text,
      textAr: textAr,
      options: optionsModel.map((o) => o.toEntity()).toList(),
    );
  }
}


