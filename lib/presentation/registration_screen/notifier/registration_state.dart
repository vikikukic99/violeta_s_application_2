part of 'registration_notifier.dart';

class RegistrationState extends Equatable {
  final TextEditingController? fullNameController;
  final TextEditingController? nicknameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool? isLoading;
  final bool? isTermsAgreed;
  final bool? isSubmitted;
  final bool? isSuccess;
  final String? errorMessage;
  final RegistrationModel? registrationModel;

  const RegistrationState({
    this.fullNameController,
    this.nicknameController,
    this.emailController,
    this.passwordController,
    this.isLoading,
    this.isTermsAgreed,
    this.isSubmitted,
    this.isSuccess,
    this.errorMessage,
    this.registrationModel,
  });

  @override
  List<Object?> get props => [
        fullNameController,
        nicknameController,
        emailController,
        passwordController,
        isLoading,
        isTermsAgreed,
        isSubmitted,
        isSuccess,
        errorMessage,
        registrationModel,
      ];

  RegistrationState copyWith({
    TextEditingController? fullNameController,
    TextEditingController? nicknameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? isLoading,
    bool? isTermsAgreed,
    bool? isSubmitted,
    bool? isSuccess,
    String? errorMessage,
    RegistrationModel? registrationModel,
  }) {
    return RegistrationState(
      fullNameController: fullNameController ?? this.fullNameController,
      nicknameController: nicknameController ?? this.nicknameController,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      isLoading: isLoading ?? this.isLoading,
      isTermsAgreed: isTermsAgreed ?? this.isTermsAgreed,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      registrationModel: registrationModel ?? this.registrationModel,
    );
  }
}
