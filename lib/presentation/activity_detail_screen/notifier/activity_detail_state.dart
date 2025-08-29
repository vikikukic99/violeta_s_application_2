part of 'activity_detail_notifier.dart';

class ActivityDetailState extends Equatable {
  final ActivityDetailModel? activityDetailModel;
  final bool isLoading;
  final bool isCancelled;

  const ActivityDetailState({
    this.activityDetailModel,
    this.isLoading = false,
    this.isCancelled = false,
  });

  @override
  List<Object?> get props => [
        activityDetailModel,
        isLoading,
        isCancelled,
      ];

  ActivityDetailState copyWith({
    ActivityDetailModel? activityDetailModel,
    bool? isLoading,
    bool? isCancelled,
  }) {
    return ActivityDetailState(
      activityDetailModel: activityDetailModel ?? this.activityDetailModel,
      isLoading: isLoading ?? this.isLoading,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}
