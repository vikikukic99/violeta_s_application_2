import '../../../core/app_export.dart';

/// This class is used in the [message_bubble_widget] widget.

// ignore_for_file: must_be_immutable
class MessageModel extends Equatable {
  MessageModel({
    this.id,
    this.text,
    this.isSentByMe,
    this.timestamp,
    this.avatarImage,
    this.isDelivered,
    this.hasAttachment,
  }) {
    id = id ?? '';
    text = text ?? '';
    isSentByMe = isSentByMe ?? false;
    timestamp = timestamp ?? '';
    avatarImage = avatarImage ?? '';
    isDelivered = isDelivered ?? false;
    hasAttachment = hasAttachment ?? false;
  }

  String? id;
  String? text;
  bool? isSentByMe;
  String? timestamp;
  String? avatarImage;
  bool? isDelivered;
  bool? hasAttachment;

  MessageModel copyWith({
    String? id,
    String? text,
    bool? isSentByMe,
    String? timestamp,
    String? avatarImage,
    bool? isDelivered,
    bool? hasAttachment,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      timestamp: timestamp ?? this.timestamp,
      avatarImage: avatarImage ?? this.avatarImage,
      isDelivered: isDelivered ?? this.isDelivered,
      hasAttachment: hasAttachment ?? this.hasAttachment,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        isSentByMe,
        timestamp,
        avatarImage,
        isDelivered,
        hasAttachment,
      ];
}
