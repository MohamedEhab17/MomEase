import 'package:dartz/dartz.dart' hide Option;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_answer.dart';
import 'package:new_mama/feature/depression/domain/usecase/get_options_usecase.dart';
import 'package:new_mama/feature/depression/domain/usecase/get_questions_usecase.dart';
import 'questions_state.dart';

@injectable
class QuestionsCubit extends SafeCubit<QuestionsState> {
  final GetQuestionsUseCase _getQuestions;
  final GetOptionsUseCase _getOptions;

  QuestionsCubit(this._getQuestions, this._getOptions) : super(QuestionsInitial());

  void fetchQuestions(int assessmentId) {
    safeEmit(QuestionsLoading());
    cancelableOperation(_getQuestions(assessmentId)).value.then((dynamic res) {
      final result = res as Either<Failure, List<Question>>;
      result.fold(
        (failure) => safeEmit(QuestionsError(failure.message)),
        (data) {
          final newState = QuestionsActive(
            questions: data,
            currentIndex: 0,
            optionsCache: const {},
            selectedAnswers: const {},
            assessmentId: assessmentId,
          );
          safeEmit(newState);
          if (data.isNotEmpty) {
            _fetchOptionsForQuestion(data[0].id);
          }
        },
      );
    });
  }

  void _fetchOptionsForQuestion(int questionId) {
    var s = state;
    if (s is! QuestionsActive) return;

    // If options are already in the cache, no need to fetch
    if (s.optionsCache.containsKey(questionId)) return;
    
    // Check if the current question already has options attached
    final currentQuestion = s.questions.firstWhere((q) => q.id == questionId, orElse: () => s.questions[s.currentIndex]);
    if (currentQuestion.options.isNotEmpty) {
       final newCache = Map<int, List<Option>>.from(s.optionsCache);
       newCache[questionId] = currentQuestion.options;
       safeEmit(s.copyWith(optionsCache: newCache));
       return;
    }

    safeEmit(s.copyWith(isLoadingOptions: true));
    
    cancelableOperation(_getOptions(questionId)).value.then((dynamic res) {
      if (isClosed) return;
      final currentState = state;
      if (currentState is! QuestionsActive) return;
      
      final result = res as Either<Failure, List<Option>>;
      result.fold(
        (failure) {
          safeEmit(currentState.copyWith(isLoadingOptions: false, error: failure.message));
        },
        (data) {
          final newCache = Map<int, List<Option>>.from(currentState.optionsCache);
          newCache[questionId] = data;
          safeEmit(currentState.copyWithoutError().copyWith(isLoadingOptions: false, optionsCache: newCache));
          
          // Pre-fetch next question's options if exists
          if (currentState.currentIndex + 1 < currentState.questions.length) {
            int nextId = currentState.questions[currentState.currentIndex + 1].id;
            if (!newCache.containsKey(nextId)) {
               _fetchOptionsForQuestion(nextId);
            }
          }
        },
      );
    });
  }


  void selectAnswer(int optionId) {
    final s = state;
    if (s is QuestionsActive) {
      final qId = s.questions[s.currentIndex].id;
      final newSelected = Map<int, int>.from(s.selectedAnswers);
      newSelected[qId] = optionId;
      safeEmit(s.copyWith(selectedAnswers: newSelected));
    }
  }

  void nextQuestion() {
    final s = state;
    if (s is QuestionsActive) {
      if (s.currentIndex < s.questions.length - 1) {
        final newIndex = s.currentIndex + 1;
        safeEmit(s.copyWith(currentIndex: newIndex));
        _fetchOptionsForQuestion(s.questions[newIndex].id);
      }
    }
  }

  void previousQuestion() {
    final s = state;
    if (s is QuestionsActive) {
      if (s.currentIndex > 0) {
        final newIndex = s.currentIndex - 1;
        safeEmit(s.copyWith(currentIndex: newIndex));
      }
    }
  }

  List<SubmitAnswer> buildSubmitAnswers() {
    final s = state;
    if (s is QuestionsActive) {
      return s.selectedAnswers.entries.map((e) => SubmitAnswer(questionId: e.key, optionId: e.value)).toList();
    }
    return [];
  }
}
