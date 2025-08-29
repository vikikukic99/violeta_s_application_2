import '../models/health_data_connection_model.dart';
import '../../../core/app_export.dart';

part 'health_data_connection_state.dart';

final healthDataConnectionNotifier = StateNotifierProvider.autoDispose<
    HealthDataConnectionNotifier, HealthDataConnectionState>(
  (ref) => HealthDataConnectionNotifier(
    HealthDataConnectionState(
      healthDataConnectionModel: HealthDataConnectionModel(),
    ),
  ),
);

class HealthDataConnectionNotifier
    extends StateNotifier<HealthDataConnectionState> {
  HealthDataConnectionNotifier(HealthDataConnectionState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      isLoading: false,
      isConnected: false,
    );
  }

  void connectHealthData() {
    state = state.copyWith(
      isLoading: true,
    );

    // Simulate health data connection process
    Future.delayed(Duration(seconds: 2), () {
      state = state.copyWith(
        isLoading: false,
        isConnected: true,
        isSuccess: true,
      );

      // Navigate to next screen after successful connection
      // This would typically be handled in the UI with ref.listen
    });
  }

  void selectHealthApp() {
    // Handle health app selection logic
    state = state.copyWith(
      selectedApp: 'Health App Selected',
    );
  }

  void skipConnection() {
    state = state.copyWith(
      isSkipped: true,
    );
  }
}
