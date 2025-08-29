import '../../../core/app_export.dart';

/// This class is used in the [activity_detail_screen] screen.

// ignore_for_file: must_be_immutable
class ActivityDetailModel extends Equatable {
  ActivityDetailModel({
    this.activityTitle,
    this.description,
    this.dateTime,
    this.duration,
    this.participants,
    this.difficulty,
    this.hostName,
    this.hostRole,
    this.hostImage,
    this.location,
    this.address,
    this.id,
  }) {
    activityTitle = activityTitle ?? 'Evening Walk';
    description = description ??
        'A refreshing walk through Riverside Park with fellow nature enthusiasts.';
    dateTime = dateTime ?? 'Sun, Jul 14 • 7:30 AM';
    duration = duration ?? '90 minutes';
    participants = participants ?? '1 joined';
    difficulty = difficulty ?? 'Easy';
    hostName = hostName ?? 'Sarah Johnson';
    hostRole = hostRole ?? 'Host • Walk Leader';
    hostImage = hostImage ?? ImageConstant.imgDivWhiteA70048x48;
    location = location ?? 'Riverside Park, East Entrance';
    address = address ?? '123 River Road, Riverside, CA 92507';
    id = id ?? '';
  }

  String? activityTitle;
  String? description;
  String? dateTime;
  String? duration;
  String? participants;
  String? difficulty;
  String? hostName;
  String? hostRole;
  String? hostImage;
  String? location;
  String? address;
  String? id;

  ActivityDetailModel copyWith({
    String? activityTitle,
    String? description,
    String? dateTime,
    String? duration,
    String? participants,
    String? difficulty,
    String? hostName,
    String? hostRole,
    String? hostImage,
    String? location,
    String? address,
    String? id,
  }) {
    return ActivityDetailModel(
      activityTitle: activityTitle ?? this.activityTitle,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      participants: participants ?? this.participants,
      difficulty: difficulty ?? this.difficulty,
      hostName: hostName ?? this.hostName,
      hostRole: hostRole ?? this.hostRole,
      hostImage: hostImage ?? this.hostImage,
      location: location ?? this.location,
      address: address ?? this.address,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        activityTitle,
        description,
        dateTime,
        duration,
        participants,
        difficulty,
        hostName,
        hostRole,
        hostImage,
        location,
        address,
        id,
      ];
}
