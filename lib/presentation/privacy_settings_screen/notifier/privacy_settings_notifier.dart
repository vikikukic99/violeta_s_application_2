import '../../../core/app_export.dart';
import '../models/blocked_user_item_model.dart';
import '../models/privacy_settings_model.dart';

part 'privacy_settings_state.dart';

final privacySettingsNotifier =
    StateNotifierProvider<PrivacySettingsNotifier, PrivacySettingsState>(
  (ref) => PrivacySettingsNotifier(
    PrivacySettingsState(
      privacySettingsModel: PrivacySettingsModel(),
    ),
  ),
);

class PrivacySettingsNotifier extends StateNotifier<PrivacySettingsState> {
  PrivacySettingsNotifier(PrivacySettingsState state) : super(state) {
    initialize();
  }

  void initialize() {
    final blockedUsers = [
      BlockedUserItemModel(
        userImage: ImageConstant.imgDivWhiteA70024x22,
        userName: 'Sarah',
        blockedDate: 'Blocked on July 13, 2023',
        isUnblocked: false,
      ),
      BlockedUserItemModel(
        userImage: ImageConstant.imgImg48x48,
        userName: 'Pera',
        blockedDate: '',
        isUnblocked: false,
      ),
      BlockedUserItemModel(
        userImage: ImageConstant.imgImg48x48,
        userName: 'Mika',
        blockedDate: '',
        isUnblocked: false,
      ),
    ];

    state = state.copyWith(
      privacySettingsModel: state.privacySettingsModel?.copyWith(
        blockedUsers: blockedUsers,
      ),
    );
  }

  void unblockUser(BlockedUserItemModel user) {
    final updatedBlockedUsers =
        state.privacySettingsModel?.blockedUsers?.map((blockedUser) {
      if (blockedUser.userName == user.userName) {
        return blockedUser.copyWith(isUnblocked: true);
      }
      return blockedUser;
    }).toList();

    state = state.copyWith(
      privacySettingsModel: state.privacySettingsModel?.copyWith(
        blockedUsers: updatedBlockedUsers,
      ),
    );
  }
}
