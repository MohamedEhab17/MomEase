import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';

abstract class DepressionHistoryState extends Equatable {
  const DepressionHistoryState();

  @override
  List<Object?> get props => [];
}

class DepressionHistoryInitial extends DepressionHistoryState {}

class DepressionHistoryLoading extends DepressionHistoryState {}

class DepressionHistoryLoaded extends DepressionHistoryState {
  final List<AssessmentResult> historyList;

  const DepressionHistoryLoaded(this.historyList);

  @override
  List<Object?> get props => [historyList];
}

class DepressionHistoryError extends DepressionHistoryState {
  final String message;

  const DepressionHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class DepressionHistoryDeleting extends DepressionHistoryState {
  final List<AssessmentResult> currentList;
  final int deletingId;

  const DepressionHistoryDeleting(this.currentList, this.deletingId);

  @override
  List<Object?> get props => [currentList, deletingId];
}
