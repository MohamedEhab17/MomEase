import 'package:new_mama/feature/depression/domain/entities/submit_answer.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_request.dart';

class SubmitAnswerModel extends SubmitAnswer {
  const SubmitAnswerModel({
    required super.questionId,
    required super.optionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'optionId': optionId,
    };
  }

  factory SubmitAnswerModel.fromEntity(SubmitAnswer entity) {
    return SubmitAnswerModel(
      questionId: entity.questionId,
      optionId: entity.optionId,
    );
  }
}

class SubmitRequestModel extends SubmitRequest {
  const SubmitRequestModel({
    required super.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'answers': answers.map((a) {
        if (a is SubmitAnswerModel) {
          return a.toJson();
        }
        return SubmitAnswerModel.fromEntity(a).toJson();
      }).toList(),
    };
  }

  factory SubmitRequestModel.fromEntity(SubmitRequest entity) {
    return SubmitRequestModel(answers: entity.answers);
  }
}
