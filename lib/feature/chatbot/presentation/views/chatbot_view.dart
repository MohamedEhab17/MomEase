import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genui/genui.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chat_input_bar.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chat_message_list.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chatbot_app_bar.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/empty_chatbot.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  double _previousViewInsetsBottom = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = _cubit;
    final repository = cubit.repository;

    final double currentViewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (currentViewInsetsBottom > _previousViewInsetsBottom && currentViewInsetsBottom > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        Future.delayed(const Duration(milliseconds: 250), _scrollToBottom);
      });
    }
    _previousViewInsetsBottom = currentViewInsetsBottom;

    return BlocListener<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: context.text.titleLarge!.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is ChatbotMessageReceived) {
          _scrollToBottom();
        }
      },
      child: Scaffold(
        backgroundColor: context.ext.colors.lightBackground,
        resizeToAvoidBottomInset: false,
        appBar: ChatbotAppBar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<List<ChatMessage>>(
                valueListenable: repository.conversation,
                builder: (context, messages, child) {
                  // Filter out internal messages for display
                  final displayMessages = messages.where((message) {
                    return message is UserMessage ||
                        message is AiTextMessage ||
                        message is AiUiMessage;
                  }).toList();

                  if (displayMessages.isEmpty) {
                    return Center(child: EmptyChatbotWidget());
                  }

                  return ValueListenableBuilder<bool>(
                    valueListenable: repository.isProcessing,
                    builder: (context, isProcessing, _) {
                      final double bottomPadding = MediaQuery.of(context).viewInsets.bottom > 0
                          ? (MediaQuery.of(context).viewInsets.bottom + 85.h)
                          : (kBottomNavigationBarHeight + 50.h);
                      return Padding(
                        padding: bottomPadding.bottomPadding,
                        child: ChatMessagesList(
                          messages: displayMessages,
                          isProcessing: isProcessing,
                          scrollController: _scrollController,
                          uiMessageProcessor: repository.a2uiMessageProcessor,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCirc,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom -
                        kBottomNavigationBarHeight
                  : 0,
              child: ValueListenableBuilder<bool>(
                valueListenable: repository.isProcessing,
                builder: (context, isProcessing, _) {
                  return ChatInputBar(
                    isProcessing: isProcessing,
                    controller: _textController,
                    onSend: _sendMessage,
                  );
                },
              ),
            ),

            // Chat input
          ],
        ),
      ),
    );
  }

  late final ChatbotCubit _cubit;
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  StreamSubscription<String>? _textResponseSubscription;
  StreamSubscription<ContentGeneratorError>? _errorSubscription;
  VoidCallback? _conversationListener;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _cubit = context.read<ChatbotCubit>();
    _conversationListener = () {
      final list = _cubit.repository.conversation.value;
      debugPrint('[GENUI FLOW] Conversation updated: ${list.length} messages in total');
      for (int idx = 0; idx < list.length; idx++) {
        final m = list[idx];
        if (m is AiUiMessage) {
          debugPrint('  -> Message #$idx: AiUiMessage (surfaceId=${m.surfaceId})');
        } else if (m is AiTextMessage) {
          debugPrint('  -> Message #$idx: AiTextMessage (length=${m.text.length})');
        } else if (m is UserMessage) {
          debugPrint('  -> Message #$idx: UserMessage (length=${m.text.length})');
        }
      }
      _scrollToBottom();
    };
    _cubit.repository.conversation.addListener(_conversationListener!);
  }

  @override
  void dispose() {
    if (_conversationListener != null) {
      _cubit.repository.conversation.removeListener(
        _conversationListener!,
      );
    }
    _textController.dispose();
    _scrollController.dispose();
    _textResponseSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _cubit.sendMessage(text);
      _textController.clear();
      // Scroll immediately after sending
      _scrollToBottom();
      // Scroll again after a short delay to account for typing indicator
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }
}
