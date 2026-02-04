import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genui/genui.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chatbot_message_widget.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/typing_indicator_widget.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.isProcessing,
    required this.scrollController,
    required this.uiMessageProcessor,
  });

  final List<ChatMessage> messages;
  final bool isProcessing;
  final ScrollController scrollController;
  final A2uiMessageProcessor uiMessageProcessor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: messages.length + (isProcessing ? 1 : 0),
      itemBuilder: (context, index) {
        // Typing indicator
        if (index == messages.length && isProcessing) {
          return const TypingIndicatorWidget();
        }

        final message = messages[index];

        if (message is UserMessage) {
          return _UserMessageBubble(message: message);
        }

        if (message is AiTextMessage) {
          return _AiTextMessageBubble(message: message);
        }

        if (message is AiUiMessage) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: GenUiSurface(
              key: message.uiKey,
              host: uiMessageProcessor,
              surfaceId: message.surfaceId,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({required this.message});

  final UserMessage message;

  @override
  Widget build(BuildContext context) {
    final text = message.parts
        .whereType<TextPart>()
        .map((part) => part.text)
        .join('\n');

    return ChatbotMessageWidget(alignment: MainAxisAlignment.end, text: text);
  }
}

class _AiTextMessageBubble extends StatelessWidget {
  const _AiTextMessageBubble({required this.message});

  final AiTextMessage message;

  @override
  Widget build(BuildContext context) {
    final text = message.parts
        .whereType<TextPart>()
        .map((part) => part.text)
        .join('\n');

    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return ChatbotMessageWidget(
      alignment: MainAxisAlignment.start,
      text: text,
    );
  }
}
