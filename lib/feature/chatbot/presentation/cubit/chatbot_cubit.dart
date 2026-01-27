import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:genui/genui.dart';
import '../../data/repositories/chatbot_repository.dart';

part 'chatbot_state.dart';

/// Cubit for managing chatbot state
/// Handles all business logic for the chatbot feature
class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit(this._repository) : super(ChatbotInitial()) {
    _initialize();
  }

  final ChatbotRepository _repository;

  /// Expose repository for UI access
  ChatbotRepository get repository => _repository;
  StreamSubscription<String>? _textResponseSubscription;
  StreamSubscription<ContentGeneratorError>? _errorSubscription;

  void _initialize() {
    // Listen to text responses
    _textResponseSubscription = _repository.textResponseStream.listen(
      (text) {
        if (text.isNotEmpty) {
          emit(ChatbotMessageReceived(text));
        }
      },
      onError: (error) {
        final errorMessage = _formatErrorMessage(error);
        emit(ChatbotError(errorMessage));
      },
    );

    // Listen to errors
    _errorSubscription = _repository.errorStream.listen((error) {
      final errorMessage = _formatErrorMessage(error);
      emit(ChatbotError(errorMessage));
    });
  }

  /// Formats error messages to be more user-friendly
  String _formatErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('quota') || errorString.contains('429')) {
      return 'API quota limit reached. Please wait a moment and try again.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Network error. Please check your connection.';
    } else if (errorString.contains('exception:')) {
      // Extract the message after "Exception:"
      return error.toString().split('Exception:').last.trim();
    }

    return error.toString();
  }

  /// Sends a message to the chatbot
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      emit(const ChatbotError('Message cannot be empty'));
      return;
    }

    if (_repository.isProcessing.value) {
      emit(
        const ChatbotError(
          'Please wait for the current message to be processed',
        ),
      );
      return;
    }

    try {
      emit(ChatbotLoading());
      await _repository.sendMessage(message);
      // State will be updated via streams
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  /// Clears the conversation
  void clearConversation() {
    emit(ChatbotInitial());
  }

  @override
  Future<void> close() {
    _textResponseSubscription?.cancel();
    _errorSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
