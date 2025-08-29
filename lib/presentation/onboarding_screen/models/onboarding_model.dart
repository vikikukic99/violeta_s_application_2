import '../../../core/app_export.dart';

/// This class is used in the [OnboardingScreen] screen.

// ignore_for_file: must_be_immutable
class OnboardingModel extends Equatable {
  OnboardingModel({
    this.appTitle,
    this.subtitle,
    this.mainImagePath,
    this.currentPageIndex,
    this.id,
  }) {
    appTitle = appTitle ?? 'WalkTalk';
    subtitle = subtitle ?? 'Track your active lifestyle';
    mainImagePath = mainImagePath ?? ImageConstant.img;
    currentPageIndex = currentPageIndex ?? 0;
    id = id ?? '';
  }

  String? appTitle;
  String? subtitle;
  String? mainImagePath;
  int? currentPageIndex;
  String? id;

  OnboardingModel copyWith({
    String? appTitle,
    String? subtitle,
    String? mainImagePath,
    int? currentPageIndex,
    String? id,
  }) {
    return OnboardingModel(
      appTitle: appTitle ?? this.appTitle,
      subtitle: subtitle ?? this.subtitle,
      mainImagePath: mainImagePath ?? this.mainImagePath,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        appTitle,
        subtitle,
        mainImagePath,
        currentPageIndex,
        id,
      ];
}
