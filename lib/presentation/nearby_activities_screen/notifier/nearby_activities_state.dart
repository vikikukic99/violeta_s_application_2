part of 'nearby_activities_notifier.dart';

class NearbyActivitiesState extends Equatable {
  final NearbyActivitiesModel? nearbyActivitiesModel;
  final bool isLoading;
  final String selectedFilter;

  NearbyActivitiesState({
    this.nearbyActivitiesModel,
    this.isLoading = false,
    this.selectedFilter = 'All',
  });

  @override
  List<Object?> get props => [
        nearbyActivitiesModel,
        isLoading,
        selectedFilter,
      ];

  NearbyActivitiesState copyWith({
    NearbyActivitiesModel? nearbyActivitiesModel,
    bool? isLoading,
    String? selectedFilter,
  }) {
    return NearbyActivitiesState(
      nearbyActivitiesModel:
          nearbyActivitiesModel ?? this.nearbyActivitiesModel,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
