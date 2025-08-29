part of 'splash_notifier.dart';

class SplashState extends Equatable {
  final SplashModel? splashModel;
  final bool isLoading;
  final bool shouldNavigate;

  const SplashState({
    this.splashModel,
    this.isLoading = false,
    this.shouldNavigate = false,
  });

  @override
  List<Object?> get props => [
        splashModel,
        isLoading,
        shouldNavigate,
      ];

  SplashState copyWith({
    SplashModel? splashModel,
    bool? isLoading,
    bool? shouldNavigate,
  }) {
    return SplashState(
      splashModel: splashModel ?? this.splashModel,
      isLoading: isLoading ?? this.isLoading,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
    );
  }
}
