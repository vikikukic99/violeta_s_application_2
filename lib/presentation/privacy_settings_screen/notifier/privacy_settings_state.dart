part of 'privacy_settings_notifier.dart';

class PrivacySettingsState extends Equatable {
  final PrivacySettingsModel? privacySettingsModel;

  const PrivacySettingsState({
    this.privacySettingsModel,
  });

  @override
  List<Object?> get props => [
        privacySettingsModel,
      ];

  PrivacySettingsState copyWith({
    PrivacySettingsModel? privacySettingsModel,
  }) {
    return PrivacySettingsState(
      privacySettingsModel: privacySettingsModel ?? this.privacySettingsModel,
    );
  }
}
