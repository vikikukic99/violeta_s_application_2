part of 'health_data_connection_notifier.dart';

class HealthDataConnectionState extends Equatable {
  final HealthDataConnectionModel? healthDataConnectionModel;
  final bool isLoading;
  final bool isConnected;
  final bool isSuccess;
  final bool isSkipped;
  final bool isManualDataSaved;
  final String? selectedApp;
  final String? errorMessage;
  final List<Map<String, dynamic>> existingIntegrations;

  HealthDataConnectionState({
    this.healthDataConnectionModel,
    this.isLoading = false,
    this.isConnected = false,
    this.isSuccess = false,
    this.isSkipped = false,
    this.isManualDataSaved = false,
    this.selectedApp,
    this.errorMessage,
    this.existingIntegrations = const [],
  });

  @override
  List<Object?> get props => [
        healthDataConnectionModel,
        isLoading,
        isConnected,
        isSuccess,
        isSkipped,
        isManualDataSaved,
        selectedApp,
        errorMessage,
        existingIntegrations,
      ];

  HealthDataConnectionState copyWith({
    HealthDataConnectionModel? healthDataConnectionModel,
    bool? isLoading,
    bool? isConnected,
    bool? isSuccess,
    bool? isSkipped,
    bool? isManualDataSaved,
    String? selectedApp,
    String? errorMessage,
    List<Map<String, dynamic>>? existingIntegrations,
  }) {
    return HealthDataConnectionState(
      healthDataConnectionModel:
          healthDataConnectionModel ?? this.healthDataConnectionModel,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      isSuccess: isSuccess ?? this.isSuccess,
      isSkipped: isSkipped ?? this.isSkipped,
      isManualDataSaved: isManualDataSaved ?? this.isManualDataSaved,
      selectedApp: selectedApp ?? this.selectedApp,
      errorMessage: errorMessage,
      existingIntegrations: existingIntegrations ?? this.existingIntegrations,
    );
  }
}
