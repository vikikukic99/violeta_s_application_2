import '../../../core/app_export.dart';

/// This class is used in the [splash_screen] screen.

// ignore_for_file: must_be_immutable
class SplashModel extends Equatable {
  SplashModel({
    this.logoImage,
    this.appTitle,
    this.appSubtitle,
  }) {
    logoImage = logoImage ?? ImageConstant.imgIGreen500;
    appTitle = appTitle ?? 'WalkTalk';
    appSubtitle = appSubtitle ?? 'Connect through movement';
  }

  String? logoImage;
  String? appTitle;
  String? appSubtitle;

  SplashModel copyWith({
    String? logoImage,
    String? appTitle,
    String? appSubtitle,
  }) {
    return SplashModel(
      logoImage: logoImage ?? this.logoImage,
      appTitle: appTitle ?? this.appTitle,
      appSubtitle: appSubtitle ?? this.appSubtitle,
    );
  }

  @override
  List<Object?> get props => [logoImage, appTitle, appSubtitle];
}
