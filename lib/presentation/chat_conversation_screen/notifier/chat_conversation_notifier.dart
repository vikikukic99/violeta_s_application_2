import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/chat_conversation_model.dart';
import '../models/message_model.dart';

part 'chat_conversation_state.dart';

final chatConversationNotifier = StateNotifierProvider.autoDispose<
    ChatConversationNotifier, ChatConversationState>(
  (ref) => ChatConversationNotifier(
    ChatConversationState(
      chatConversationModel: ChatConversationModel(),
    ),
  ),
);

class ChatConversationNotifier extends StateNotifier<ChatConversationState> {
  ChatConversationNotifier(ChatConversationState state) : super(state) {
    initialize();
  }

  void initialize() {
    List<MessageModel> messages = [
      MessageModel(
        id: '1',
        text:
            'Hey, how\'s it going? Are we still meeting for coffee later today?',
        isSentByMe: false,
        timestamp: '9:32 AM',
        avatarImage: ImageConstant.imgImg,
      ),
      MessageModel(
        id: '2',
        text: 'Hi Alex! Yes, absolutely. How about 3 PM at the usual place?',
        isSentByMe: true,
        timestamp: '9:35 AM',
        isDelivered: true,
      ),
      MessageModel(
        id: '3',
        text:
            'Perfect! 3 PM works for me. I wanted to discuss that new project idea with you.',
        isSentByMe: false,
        timestamp: '9:40 AM',
        avatarImage: ImageConstant.imgImg,
      ),
      MessageModel(
        id: '4',
        text:
            'Great! I\'m excited to hear about it. I\'ve been brainstorming some ideas myself.',
        isSentByMe: true,
        timestamp: '9:42 AM',
        isDelivered: true,
      ),
      MessageModel(
        id: '5',
        text:
            'I made a quick mockup of what I\'m thinking. Something like this:',
        isSentByMe: false,
        timestamp: '10:05 AM',
        avatarImage: ImageConstant.imgImg,
        hasAttachment: true,
      ),
      MessageModel(
        id: '6',
        text:
            'Wow, that looks amazing! Can\'t wait to discuss the details. I\'ll bring my laptop so we can work on it together.',
        isSentByMe: true,
        timestamp: '10:10 AM',
        isDelivered: true,
      ),
    ];

    state = state.copyWith(
      messageController: TextEditingController(),
      messages: messages,
    );
  }

  void sendMessage() {
    if (state.messageController?.text.trim().isEmpty == true) return;

    String messageText = state.messageController!.text.trim();
    MessageModel newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageText,
      isSentByMe: true,
      timestamp: _getCurrentTime(),
      isDelivered: false,
    );

    List<MessageModel> updatedMessages = [
      ...(state.messages ?? []),
      newMessage
    ];

    state = state.copyWith(
      messages: updatedMessages,
    );

    state.messageController?.clear();

    // Simulate message delivery
    Future.delayed(Duration(seconds: 1), () {
      MessageModel deliveredMessage = newMessage.copyWith(isDelivered: true);
      List<MessageModel> messages = state.messages?.map((msg) {
            return msg.id == newMessage.id ? deliveredMessage : msg;
          }).toList() ??
          [];

      state = state.copyWith(messages: messages);
    });
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String period = now.hour >= 12 ? 'PM' : 'AM';
    int hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
            ? 12
            : now.hour;
    String minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    state.messageController?.dispose();
    super.dispose();
  }
}
