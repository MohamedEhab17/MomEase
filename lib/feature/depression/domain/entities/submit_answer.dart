import 'package:equatable/equatable.dart';

class SubmitAnswer extends Equatable {
  final int questionId;
  final int optionId;

  const SubmitAnswer({
    required this.questionId,
    required this.optionId,
  });

  @override
  List<Object?> get props => [questionId, optionId];
}
