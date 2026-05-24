import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';

abstract class AssessmentResultState extends Equatable {
  const AssessmentResultState();

  @override
  List<Object?> get props => [];
}

class AssessmentResultInitial extends AssessmentResultState {}

class AssessmentResultLoading extends AssessmentResultState {}

class AssessmentResultSuccess extends AssessmentResultState {
  final AssessmentResult result;

  const AssessmentResultSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class AssessmentResultError extends AssessmentResultState {
  final String message;

  const AssessmentResultError(this.message);

  @override
  List<Object?> get props => [message];
}
