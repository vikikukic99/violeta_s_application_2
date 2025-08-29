part of 'onboarding_notifier.dart';

class OnboardingState extends Equatable {
  final OnboardingModel? onboardingModel;
  final bool isLoading;

  OnboardingState({
    this.onboardingModel,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        onboardingModel,
        isLoading,
      ];

  OnboardingState copyWith({
    OnboardingModel? onboardingModel,
    bool? isLoading,
  }) {
    return OnboardingState(
      onboardingModel: onboardingModel ?? this.onboardingModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
