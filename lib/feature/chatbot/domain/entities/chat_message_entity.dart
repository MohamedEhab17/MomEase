import 'package:equatable/equatable.dart';

/// Entity representing a chat message
/// Part of domain layer in clean architecture
class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  @override
  List<Object> get props => [id, text, isUser, timestamp];
}
