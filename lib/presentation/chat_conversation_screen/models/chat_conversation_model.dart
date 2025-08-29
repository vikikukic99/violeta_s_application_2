import '../../../core/app_export.dart';

/// This class is used in the [chat_conversation_screen] screen.

// ignore_for_file: must_be_immutable
class ChatConversationModel extends Equatable {
  ChatConversationModel({
    this.contactName,
    this.contactStatus,
    this.contactAvatar,
  }) {
    contactName = contactName ?? 'Alex Johnson';
    contactStatus = contactStatus ?? 'Online';
    contactAvatar = contactAvatar ?? ImageConstant.imgDivGreenA700;
  }

  String? contactName;
  String? contactStatus;
  String? contactAvatar;

  ChatConversationModel copyWith({
    String? contactName,
    String? contactStatus,
    String? contactAvatar,
  }) {
    return ChatConversationModel(
      contactName: contactName ?? this.contactName,
      contactStatus: contactStatus ?? this.contactStatus,
      contactAvatar: contactAvatar ?? this.contactAvatar,
    );
  }

  @override
  List<Object?> get props => [contactName, contactStatus, contactAvatar];
}
