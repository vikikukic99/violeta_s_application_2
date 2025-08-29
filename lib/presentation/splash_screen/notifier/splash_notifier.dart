import '../models/splash_model.dart';
import '../../../core/app_export.dart';

part 'splash_state.dart';

final splashNotifier =
    StateNotifierProvider.autoDispose<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(
    SplashState(
      splashModel: SplashModel(),
    ),
  ),
);

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier(SplashState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      isLoading: true,
      shouldNavigate: false,
    );
  }

  void navigateToNextScreen() {
    state = state.copyWith(
      isLoading: false,
      shouldNavigate: true,
    );
  }
}
