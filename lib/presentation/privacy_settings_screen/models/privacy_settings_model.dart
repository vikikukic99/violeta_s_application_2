import '../../../core/app_export.dart';
import './blocked_user_item_model.dart';

/// This class is used in the [privacy_settings_screen] screen.

// ignore_for_file: must_be_immutable
class PrivacySettingsModel extends Equatable {
  PrivacySettingsModel({this.blockedUsers, this.searchQuery}) {
    blockedUsers = blockedUsers ?? [];
    searchQuery = searchQuery ?? '';
  }

  List<BlockedUserItemModel>? blockedUsers;
  String? searchQuery;

  PrivacySettingsModel copyWith({
    List<BlockedUserItemModel>? blockedUsers,
    String? searchQuery,
  }) {
    return PrivacySettingsModel(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [blockedUsers, searchQuery];
}
