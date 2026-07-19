import 'package:equatable/equatable.dart';
import 'submit_answer.dart';

class SubmitRequest extends Equatable {
  final List<SubmitAnswer> answers;

  const SubmitRequest({
    required this.answers,
  });

  @override
  List<Object?> get props => [answers];
}
