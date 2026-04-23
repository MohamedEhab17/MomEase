import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';


abstract class SubmitState extends Equatable {
  const SubmitState();
  @override
  List<Object?> get props => [];
}

class SubmitInitial extends SubmitState {}

class SubmitLoading extends SubmitState {}

class SubmitSuccess extends SubmitState {
  final AssessmentResult result;
  const SubmitSuccess(this.result);
  @override
  List<Object?> get props => [result];
}


class SubmitError extends SubmitState {
  final String message;
  const SubmitError(this.message);
  @override
  List<Object?> get props => [message];
}
