part of 'health_dashboard_notifier.dart';

class HealthDashboardState extends Equatable {
  final HealthDashboardModel healthDashboard;
  final String selectedMetric;

  const HealthDashboardState({
    required this.healthDashboard,
    this.selectedMetric = 'steps',
  });

  @override
  List<Object?> get props => [
        healthDashboard,
        selectedMetric,
      ];

  HealthDashboardState copyWith({
    HealthDashboardModel? healthDashboard,
    String? selectedMetric,
  }) {
    return HealthDashboardState(
      healthDashboard: healthDashboard ?? this.healthDashboard,
      selectedMetric: selectedMetric ?? this.selectedMetric,
    );
  }
}