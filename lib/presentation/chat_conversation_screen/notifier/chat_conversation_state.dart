part of 'chat_conversation_notifier.dart';

class ChatConversationState extends Equatable {
  final TextEditingController? messageController;
  final List<MessageModel>? messages;
  final bool isLoading;
  final ChatConversationModel? chatConversationModel;

  const ChatConversationState({
    this.messageController,
    this.messages,
    this.isLoading = false,
    this.chatConversationModel,
  });

  @override
  List<Object?> get props => [
        messageController,
        messages,
        isLoading,
        chatConversationModel,
      ];

  ChatConversationState copyWith({
    TextEditingController? messageController,
    List<MessageModel>? messages,
    bool? isLoading,
    ChatConversationModel? chatConversationModel,
  }) {
    return ChatConversationState(
      messageController: messageController ?? this.messageController,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      chatConversationModel:
          chatConversationModel ?? this.chatConversationModel,
    );
  }
}
