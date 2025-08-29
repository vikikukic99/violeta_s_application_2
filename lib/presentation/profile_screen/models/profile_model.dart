import '../../../core/app_export.dart';

class ProfileModel extends Equatable {
  String? profileImage;
  String? userName;
  String? userHandle;
  String? aboutText;

  ProfileModel({
    this.profileImage,
    this.userName,
    this.userHandle,
    this.aboutText,
  }) {
    profileImage = profileImage ?? ImageConstant.imgImg104x104;
    userName = userName ?? 'Sarah Johnson';
    userHandle = userHandle ?? '@sarahjwalk';
    aboutText = aboutText ??
        'Hiking enthusiast and nature lover. I enjoy organizing group walks and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾';
  }

  @override
  List<Object?> get props => [
        profileImage,
        userName,
        userHandle,
        aboutText,
      ];

  ProfileModel copyWith({
    String? profileImage,
    String? userName,
    String? userHandle,
    String? aboutText,
  }) {
    return ProfileModel(
      profileImage: profileImage ?? this.profileImage,
      userName: userName ?? this.userName,
      userHandle: userHandle ?? this.userHandle,
      aboutText: aboutText ?? this.aboutText,
    );
  }
}
