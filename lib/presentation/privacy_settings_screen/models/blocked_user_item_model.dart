import '../../../core/app_export.dart';

/// This class is used in the [blocked_user_item_widget] widget.

// ignore_for_file: must_be_immutable
class BlockedUserItemModel extends Equatable {
  BlockedUserItemModel({
    this.userImage,
    this.userName,
    this.blockedDate,
    this.isUnblocked,
  }) {
    userImage = userImage ?? '';
    userName = userName ?? '';
    blockedDate = blockedDate ?? '';
    isUnblocked = isUnblocked ?? false;
  }

  String? userImage;
  String? userName;
  String? blockedDate;
  bool? isUnblocked;

  BlockedUserItemModel copyWith({
    String? userImage,
    String? userName,
    String? blockedDate,
    bool? isUnblocked,
  }) {
    return BlockedUserItemModel(
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      blockedDate: blockedDate ?? this.blockedDate,
      isUnblocked: isUnblocked ?? this.isUnblocked,
    );
  }

  @override
  List<Object?> get props => [userImage, userName, blockedDate, isUnblocked];
}
