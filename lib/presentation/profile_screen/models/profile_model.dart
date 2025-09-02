import '../../../core/app_export.dart';

class ProfileModel extends Equatable {
  String? profileImage;
  String? userName;
  String? userHandle;
  String? aboutText;
  String? location;
  String? totalActivities;
  String? connections;
  String? points;

  ProfileModel({
    this.profileImage,
    this.userName,
    this.userHandle,
    this.aboutText,
    this.location,
    this.totalActivities,
    this.connections,
    this.points,
  }) {
    profileImage = profileImage ?? ImageConstant.imgImg104x104;
    userName = userName ?? 'Sarah Johnson';
    userHandle = userHandle ?? '@sarahjwalk';
    aboutText = aboutText ??
        'Hiking enthusiast and nature lover. I enjoy organizing group walks and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾';
    location = location ?? 'New York, NY';
    totalActivities = totalActivities ?? '23';
    connections = connections ?? '156';
    points = points ?? '2.4K';
  }

  @override
  List<Object?> get props => [
        profileImage,
        userName,
        userHandle,
        aboutText,
        location,
        totalActivities,
        connections,
        points,
      ];

  ProfileModel copyWith({
    String? profileImage,
    String? userName,
    String? userHandle,
    String? aboutText,
    String? location,
    String? totalActivities,
    String? connections,
    String? points,
  }) {
    return ProfileModel(
      profileImage: profileImage ?? this.profileImage,
      userName: userName ?? this.userName,
      userHandle: userHandle ?? this.userHandle,
      aboutText: aboutText ?? this.aboutText,
      location: location ?? this.location,
      totalActivities: totalActivities ?? this.totalActivities,
      connections: connections ?? this.connections,
      points: points ?? this.points,
    );
  }
}
