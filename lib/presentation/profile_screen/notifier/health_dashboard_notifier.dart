import '../../../core/app_export.dart';
import '../../../services/health_service.dart';
import '../models/health_dashboard_model.dart';

part 'health_dashboard_state.dart';

final healthDashboardNotifierProvider =
    StateNotifierProvider.autoDispose<HealthDashboardNotifier, HealthDashboardState>(
  (ref) => HealthDashboardNotifier(
    const HealthDashboardState(
      healthDashboard: HealthDashboardModel(isLoading: true),
      selectedMetric: 'steps',
    ),
  ),
);

class HealthDashboardNotifier extends StateNotifier<HealthDashboardState> {
  final HealthService _healthService = HealthService();

  HealthDashboardNotifier(HealthDashboardState state) : super(state) {
    loadHealthDashboard();
  }

  Future<void> loadHealthDashboard() async {
    state = state.copyWith(
      healthDashboard: state.healthDashboard.copyWith(isLoading: true, error: null),
    );

    try {
      final dashboard = await _healthService.getHealthDashboard();
      state = state.copyWith(healthDashboard: dashboard);
    } catch (e) {
      state = state.copyWith(
        healthDashboard: state.healthDashboard.copyWith(
          isLoading: false,
          error: 'Failed to load health data',
        ),
      );
    }
  }

  Future<void> refreshHealthData() async {
    // Don't show loading for refresh, just update the data
    try {
      final dashboard = await _healthService.getHealthDashboard();
      state = state.copyWith(healthDashboard: dashboard);
    } catch (e) {
      // Silently fail on refresh to avoid disrupting user experience
      print('Error refreshing health data: $e');
    }
  }

  void changeSelectedMetric(String metric) {
    state = state.copyWith(selectedMetric: metric);
  }

  Future<void> updateDailyActivity(DailyHealthDataModel activity) async {
    try {
      final success = await _healthService.saveDailyActivity(activity);
      if (success) {
        // Refresh the dashboard to show updated data
        await refreshHealthData();
      }
    } catch (e) {
      print('Error updating daily activity: $e');
    }
  }

  Future<void> updateHealthGoals(HealthGoalsModel goals) async {
    try {
      final success = await _healthService.saveHealthProfile(goals);
      if (success) {
        // Update local state with new goals
        final updatedDashboard = state.healthDashboard.copyWith(goals: goals);
        state = state.copyWith(healthDashboard: updatedDashboard);
        
        // Refresh to get updated stats with new goals
        await refreshHealthData();
      }
    } catch (e) {
      print('Error updating health goals: $e');
    }
  }

  // Get formatted stats for quick display
  String getFormattedSteps() {
    final steps = state.healthDashboard.todayStats?.steps ?? 0;
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return steps.toString();
  }

  String getFormattedCalories() {
    final calories = state.healthDashboard.todayStats?.calories ?? 0;
    return calories.toString();
  }

  String getFormattedDistance() {
    final distance = state.healthDashboard.todayStats?.distance ?? 0.0;
    return '${distance.toStringAsFixed(1)} km';
  }

  String getFormattedActiveMinutes() {
    final minutes = state.healthDashboard.todayStats?.activeMinutes ?? 0;
    return '$minutes min';
  }

  // Check if user has any health data
  bool get hasHealthData {
    final dashboard = state.healthDashboard;
    return dashboard.todayStats != null &&
        (dashboard.todayStats!.steps > 0 ||
         dashboard.todayStats!.calories > 0 ||
         dashboard.todayStats!.distance > 0);
  }

  // Check if user has connected services
  bool get hasConnectedServices {
    return state.healthDashboard.connectedServices?.isNotEmpty ?? false;
  }

  // Get completion status for today's goals
  Map<String, bool> get todayGoalsCompletion {
    final stats = state.healthDashboard.todayStats;
    if (stats == null) return {};

    return {
      'steps': stats.stepsProgress >= 1.0,
      'calories': stats.caloriesProgress >= 1.0,
      'activeMinutes': stats.activeMinutesProgress >= 1.0,
      'water': stats.waterProgress >= 1.0,
      'sleep': stats.sleepProgress >= 1.0,
    };
  }

  // Get overall progress percentage for today
  double get todayOverallProgress {
    final completion = todayGoalsCompletion;
    if (completion.isEmpty) return 0.0;

    final completedGoals = completion.values.where((completed) => completed).length;
    return completedGoals / completion.length;
  }
}