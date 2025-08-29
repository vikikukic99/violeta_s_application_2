part of 'health_data_connection_notifier.dart';

class HealthDataConnectionState extends Equatable {
  final HealthDataConnectionModel? healthDataConnectionModel;
  final bool isLoading;
  final bool isConnected;
  final bool isSuccess;
  final bool isSkipped;
  final String? selectedApp;

  HealthDataConnectionState({
    this.healthDataConnectionModel,
    this.isLoading = false,
    this.isConnected = false,
    this.isSuccess = false,
    this.isSkipped = false,
    this.selectedApp,
  });

  @override
  List<Object?> get props => [
        healthDataConnectionModel,
        isLoading,
        isConnected,
        isSuccess,
        isSkipped,
        selectedApp,
      ];

  HealthDataConnectionState copyWith({
    HealthDataConnectionModel? healthDataConnectionModel,
    bool? isLoading,
    bool? isConnected,
    bool? isSuccess,
    bool? isSkipped,
    String? selectedApp,
  }) {
    return HealthDataConnectionState(
      healthDataConnectionModel:
          healthDataConnectionModel ?? this.healthDataConnectionModel,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      isSuccess: isSuccess ?? this.isSuccess,
      isSkipped: isSkipped ?? this.isSkipped,
      selectedApp: selectedApp ?? this.selectedApp,
    );
  }
}
