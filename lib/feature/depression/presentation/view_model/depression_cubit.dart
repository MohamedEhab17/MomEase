import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/dummy/dummy_questions.dart';
import 'depression_state.dart';

class DepressionCubit extends Cubit<DepressionState> {
  DepressionCubit() : super(DepressionInitial());

  int _currentIndex = 0;
  int _totalScore = 0;
  int? _selectedAnswerIndex;

  void startTest() {
    _currentIndex = 0;
    _totalScore = 0;
    _selectedAnswerIndex = null;
    emit(
      DepressionAnswering(
        currentIndex: _currentIndex,
        totalScore: _totalScore,
        selectedAnswerIndex: _selectedAnswerIndex,
      ),
    );
  }

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    emit(
      DepressionAnswering(
        currentIndex: _currentIndex,
        totalScore: _totalScore,
        selectedAnswerIndex: _selectedAnswerIndex,
      ),
    );
  }

  void nextQuestion() {
    if (_selectedAnswerIndex != null) {
      _totalScore += _selectedAnswerIndex!;

      if (_currentIndex < dummyDepressionQuestions.length - 1) {
        _currentIndex++;
        _selectedAnswerIndex = null;
        emit(
          DepressionAnswering(
            currentIndex: _currentIndex,
            totalScore: _totalScore,
            selectedAnswerIndex: _selectedAnswerIndex,
          ),
        );
      } else {
        emit(DepressionFinished(totalScore: _totalScore));
      }
    }
  }

  String getSeverityResult() {
    if (_totalScore <= 4) return 'Minimal';
    if (_totalScore <= 9) return 'Mild';
    if (_totalScore <= 14) return 'Moderate';
    if (_totalScore <= 19) return 'Moderately Severe';
    return 'Severe';
  }
}
