import '../../../core/app_export.dart';
import './activity_item_model.dart';

class NearbyActivitiesModel extends Equatable {
  List<ActivityItemModel>? activityItemsList;
  String? selectedFilter;
  String? distanceFilter;

  NearbyActivitiesModel({
    this.activityItemsList,
    this.selectedFilter,
    this.distanceFilter,
  }) {
    activityItemsList = activityItemsList ?? [];
    selectedFilter = selectedFilter ?? 'All';
    distanceFilter = distanceFilter ?? '5km';
  }

  @override
  List<Object?> get props => [
        activityItemsList,
        selectedFilter,
        distanceFilter,
      ];

  NearbyActivitiesModel copyWith({
    List<ActivityItemModel>? activityItemsList,
    String? selectedFilter,
    String? distanceFilter,
  }) {
    return NearbyActivitiesModel(
      activityItemsList: activityItemsList ?? this.activityItemsList,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      distanceFilter: distanceFilter ?? this.distanceFilter,
    );
  }
}
