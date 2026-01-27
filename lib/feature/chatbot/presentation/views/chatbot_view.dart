import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genui/genui.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chatbot_app_bar.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/empty_chatbot.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/typing_indicator_widget.dart';

/// Main view for the chatbot feature
/// Displays conversation and handles user input
class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatbotCubit>();
    final repository = cubit.repository;

    return BlocListener<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppStyles.styleRoboto16.copyWith(color: Colors.white),
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
        backgroundColor: AppColors.lightBackground,
        appBar: ChatbotAppBar(),
        body: Column(
          children: [
            Expanded(
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
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount:
                            displayMessages.length + (isProcessing ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show typing indicator at the end when processing
                          if (index == displayMessages.length && isProcessing) {
                            return const TypingIndicatorWidget();
                          }

                          final message = displayMessages[index];
                          if (message is UserMessage) {
                            final text = message.parts
                                .whereType<TextPart>()
                                .map((part) => part.text)
                                .join('\n');
                            return ChatMessageWidget(
                              icon: Icons.person,
                              alignment: MainAxisAlignment.end,
                              text: text,
                            );
                          } else if (message is AiTextMessage) {
                            final text = message.parts
                                .whereType<TextPart>()
                                .map((part) => part.text)
                                .join('\n');
                            if (text.trim().isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return ChatMessageWidget(
                              text: text,
                              icon: Icons.smart_toy_outlined,
                              alignment: MainAxisAlignment.start,
                            );
                          } else if (message is AiUiMessage) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              child: GenUiSurface(
                                key: message.uiKey,
                                host: repository.a2uiMessageProcessor,
                                surfaceId: message.surfaceId,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Chat input
            ValueListenableBuilder<bool>(
              valueListenable: repository.isProcessing,
              builder: (context, isProcessing, child) {
                return TextFormFieldHelper(
                  controller: _textController,
                  enabled: !isProcessing,
                  hint: 'Type your message here..',
                  onFieldSubmitted: (value) => _sendMessage(),
                  suffixWidget: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        alignment: Alignment.center,
                        child: isProcessing
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.send,
                                color: AppColors.primarySoft,
                                size: 24.sp,
                              ),
                      ),
                    ),
                  ),
                );
                // return ChatInputWidget(
                //   controller: _textController,
                //   onSend: _sendMessage,
                //   isLoading: isProcessing,
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  StreamSubscription<String>? _textResponseSubscription;
  StreamSubscription<ContentGeneratorError>? _errorSubscription;
  VoidCallback? _conversationListener;

  @override
  void initState() {
    super.initState();
    _textController = .new();
    _scrollController = .new();
    // Set up listener for conversation changes to auto-scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ChatbotCubit>();
      _conversationListener = () {
        _scrollToBottom();
      };
      cubit.repository.conversation.addListener(_conversationListener!);
    });
  }

  @override
  void dispose() {
    if (_conversationListener != null) {
      context.read<ChatbotCubit>().repository.conversation.removeListener(
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
      context.read<ChatbotCubit>().sendMessage(text);
      _textController.clear();
      // Scroll immediately after sending
      _scrollToBottom();
      // Scroll again after a short delay to account for typing indicator
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }
}
