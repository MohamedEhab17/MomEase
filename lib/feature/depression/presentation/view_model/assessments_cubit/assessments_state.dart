import 'package:new_mama/feature/depression/domain/entities/assessments.dart';

abstract class AssessmentsState {}

class AssessmentsInitial extends AssessmentsState {}

class AssessmentsLoading extends AssessmentsState {}

class AssessmentsLoaded extends AssessmentsState {
  final List<Assessments> assessments;

  AssessmentsLoaded(this.assessments);
}

class AssessmentsError extends AssessmentsState {
  final String message;

  AssessmentsError(this.message);
}