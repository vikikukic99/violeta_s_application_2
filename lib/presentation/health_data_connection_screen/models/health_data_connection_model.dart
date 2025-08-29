import '../../../core/app_export.dart';

/// This class is used in the [HealthDataConnectionScreen] screen.

// ignore_for_file: must_be_immutable
class HealthDataConnectionModel extends Equatable {
  HealthDataConnectionModel({
    this.appLogo,
    this.appName,
    this.title,
    this.description,
    this.benefits,
    this.privacyNote,
    this.id,
  }) {
    appLogo = appLogo ?? ImageConstant.imgFrame;
    appName = appName ?? 'WalkTalk';
    title = title ?? 'Connect Health Data';
    description = description ??
        'Connect your health app to track your steps, distance, and activity automatically. WalkTalk uses this data to provide personalized insights and challenges.';
    benefits = benefits ??
        [
          'Automatic step and activity tracking',
          'Personalized fitness insights',
          'Compete in challenges with friends',
        ];
    privacyNote = privacyNote ??
        'Your health data is private and secure. We only access the data you allow.';
    id = id ?? '';
  }

  String? appLogo;
  String? appName;
  String? title;
  String? description;
  List<String>? benefits;
  String? privacyNote;
  String? id;

  HealthDataConnectionModel copyWith({
    String? appLogo,
    String? appName,
    String? title,
    String? description,
    List<String>? benefits,
    String? privacyNote,
    String? id,
  }) {
    return HealthDataConnectionModel(
      appLogo: appLogo ?? this.appLogo,
      appName: appName ?? this.appName,
      title: title ?? this.title,
      description: description ?? this.description,
      benefits: benefits ?? this.benefits,
      privacyNote: privacyNote ?? this.privacyNote,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props =>
      [appLogo, appName, title, description, benefits, privacyNote, id];
}
