import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final int id;
  final int questionId;
  final String text;
  final String? textAr;
  final int score;
  final int optionOrder;

  const Option({
    required this.id,
    required this.questionId,
    required this.text,
    this.textAr,
    required this.score,
    required this.optionOrder,
  });

  @override
  List<Object?> get props => [id, questionId, text, textAr, score, optionOrder];
}
