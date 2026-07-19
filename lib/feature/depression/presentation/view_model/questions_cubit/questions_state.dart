import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';

abstract class QuestionsState extends Equatable {
  const QuestionsState();
  @override
  List<Object?> get props => [];
}

class QuestionsInitial extends QuestionsState {}

class QuestionsLoading extends QuestionsState {}

class QuestionsActive extends QuestionsState {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, List<Option>> optionsCache; 
  final Map<int, int> selectedAnswers; 
  final int assessmentId;
  final bool isLoadingOptions;
  final String? error;

  const QuestionsActive({
    required this.questions,
    required this.currentIndex,
    required this.optionsCache,
    required this.selectedAnswers,
    required this.assessmentId,
    this.isLoadingOptions = false,
    this.error,
  });

  QuestionsActive copyWith({
    List<Question>? questions,
    int? currentIndex,
    Map<int, List<Option>>? optionsCache,
    Map<int, int>? selectedAnswers,
    int? assessmentId,
    bool? isLoadingOptions,
    String? error,
  }) {
    return QuestionsActive(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      optionsCache: optionsCache ?? this.optionsCache,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      assessmentId: assessmentId ?? this.assessmentId,
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      error: error ?? this.error, // allow null setting inherently handled properly.
    );
  }
  
  // Custom copyWith extensions to clear error
  QuestionsActive copyWithoutError() {
      return QuestionsActive(
      questions: questions,
      currentIndex: currentIndex,
      optionsCache: optionsCache,
      selectedAnswers: selectedAnswers,
      assessmentId: assessmentId,
      isLoadingOptions: isLoadingOptions,
      error: null,
    );
  }

  @override
  List<Object?> get props => [questions, currentIndex, optionsCache, selectedAnswers, assessmentId, isLoadingOptions, error];
}

class QuestionsError extends QuestionsState {
  final String message;
  const QuestionsError(this.message);
  @override
  List<Object?> get props => [message];
}
