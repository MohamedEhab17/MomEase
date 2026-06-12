part of 'chatbot_cubit.dart';

/// Base state for chatbot
abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object> get props => [];
}

/// Initial state when chatbot is first loaded
class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

/// State when chatbot is processing a message
class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

/// State when a message is received from the AI
class ChatbotMessageReceived extends ChatbotState {
  const ChatbotMessageReceived(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

/// State when an error occurs
class ChatbotError extends ChatbotState {
  const ChatbotError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
