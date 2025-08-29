import '../../../core/app_export.dart';
import '../models/activity_detail_model.dart';

part 'activity_detail_state.dart';

final activityDetailNotifierProvider = StateNotifierProvider.autoDispose<
    ActivityDetailNotifier, ActivityDetailState>(
  (ref) => ActivityDetailNotifier(
    ActivityDetailState(
      activityDetailModel: ActivityDetailModel(),
    ),
  ),
);

class ActivityDetailNotifier extends StateNotifier<ActivityDetailState> {
  ActivityDetailNotifier(ActivityDetailState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      activityDetailModel: ActivityDetailModel(
        activityTitle: 'Evening Walk',
        description:
            'A refreshing walk through Riverside Park with fellow nature enthusiasts.',
        dateTime: 'Sun, Jul 14 • 7:30 AM',
        duration: '90 minutes',
        participants: '1 joined',
        difficulty: 'Easy',
        hostName: 'Sarah Johnson',
        hostRole: 'Host • Walk Leader',
        hostImage: ImageConstant.imgDivWhiteA70048x48,
        location: 'Riverside Park, East Entrance',
        address: '123 River Road, Riverside, CA 92507',
      ),
      isLoading: false,
    );
  }

  void cancelWalk() {
    state = state.copyWith(isLoading: true);

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          isCancelled: true,
        );
      }
    });
  }
}
