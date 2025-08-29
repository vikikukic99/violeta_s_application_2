import '../models/onboarding_model.dart';
import '../../../core/app_export.dart';

part 'onboarding_state.dart';

final onboardingNotifier =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(
    OnboardingState(
      onboardingModel: OnboardingModel(),
    ),
  ),
);

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(OnboardingState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      isLoading: false,
    );
  }

  void navigateToRegistration() {
    state = state.copyWith(
      isLoading: true,
    );

    // Navigation logic will be handled in the UI
    state = state.copyWith(
      isLoading: false,
    );
  }
}
