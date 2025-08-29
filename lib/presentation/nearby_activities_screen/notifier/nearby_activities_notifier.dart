import '../../../core/app_export.dart';
import '../models/activity_item_model.dart';
import '../models/nearby_activities_model.dart';

part 'nearby_activities_state.dart';

final nearbyActivitiesNotifier = StateNotifierProvider.autoDispose<
    NearbyActivitiesNotifier, NearbyActivitiesState>(
  (ref) => NearbyActivitiesNotifier(
    NearbyActivitiesState(
      nearbyActivitiesModel: NearbyActivitiesModel(),
    ),
  ),
);

class NearbyActivitiesNotifier extends StateNotifier<NearbyActivitiesState> {
  NearbyActivitiesNotifier(NearbyActivitiesState state) : super(state) {
    initialize();
  }

  void initialize() {
    List<ActivityItemModel> activityItemsList = [
      ActivityItemModel(
        iconPath: ImageConstant.imgIWhiteA700,
        iconBackgroundColor: appTheme.green_500,
        title: 'Evening Walk',
        location: 'Central Park • 2.5 km away',
        status: 'In 30 min',
        statusBackgroundColor: appTheme.amber_300_33,
        statusTextColor: appTheme.amber_800,
        leaderImage: ImageConstant.imgDivWhiteA70024x22,
        leaderName: 'Sarah Johnson • Walk leader',
      ),
      ActivityItemModel(
        iconPath: ImageConstant.imgIWhiteA70040x40,
        iconBackgroundColor: appTheme.amber_500,
        title: 'RUN',
        location: 'Riverside • 1.2 km away',
        status: 'Now',
        statusBackgroundColor: appTheme.green_50,
        statusTextColor: appTheme.green_800,
        leaderImage: ImageConstant.imgDivWhiteA70024x22,
        leaderName: 'Sarah Johnson • Walk leader',
      ),
      ActivityItemModel(
        iconPath: ImageConstant.imgI40x40,
        iconBackgroundColor: appTheme.blue_300,
        title: 'Weekend Cycling',
        location: 'Mountain Trail • 4.8 km away',
        status: 'Tomorrow',
        statusBackgroundColor: appTheme.gray_100,
        statusTextColor: appTheme.blue_gray_800,
        leaderImage: ImageConstant.imgDivWhiteA70024x22,
        leaderName: 'Sarah Johnson • Walk leader',
      ),
      ActivityItemModel(
        iconPath: ImageConstant.imgI1,
        iconBackgroundColor: appTheme.amber_700,
        title: 'Dog Walk',
        location: 'Dog Park • 3.1 km away',
        status: 'In 2 hours',
        statusBackgroundColor: appTheme.amber_300_33,
        statusTextColor: appTheme.amber_800,
        leaderImage: ImageConstant.imgDivWhiteA70024x22,
        leaderName: 'Sarah Johnson • Walk leader',
      ),
      ActivityItemModel(
        iconPath: ImageConstant.imgI2,
        iconBackgroundColor: appTheme.green_A700,
        title: 'Nature Hike',
        location: 'Green Valley • 7.5 km away',
        status: 'Saturday',
        statusBackgroundColor: appTheme.gray_100,
        statusTextColor: appTheme.blue_gray_800,
        leaderImage: ImageConstant.imgDivWhiteA70024x22,
        leaderName: 'Sarah Johnson • Walk leader',
      ),
    ];

    state = state.copyWith(
      nearbyActivitiesModel: state.nearbyActivitiesModel?.copyWith(
        activityItemsList: activityItemsList,
      ),
      isLoading: false,
    );
  }

  void selectFilter(String filterType) {
    state = state.copyWith(selectedFilter: filterType);
  }

  void refreshActivities() {
    state = state.copyWith(isLoading: true);
    initialize();
  }
}
