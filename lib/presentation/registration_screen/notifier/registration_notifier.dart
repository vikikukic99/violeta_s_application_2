import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/registration_model.dart';

part 'registration_state.dart';

final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier(const RegistrationState());
});

/// A notifier that manages the state of a Registration Screen.
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier(RegistrationState state) : super(state) {
    _initializeControllers();
  }

  void _initializeControllers() {
    state = state.copyWith(
      fullNameController: TextEditingController(),
      nicknameController: TextEditingController(),
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      isLoading: false,
      isTermsAgreed: false,
      isSubmitted: false,
      isSuccess: false,
      errorMessage: null,
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    state.fullNameController?.dispose();
    state.nicknameController?.dispose();
    state.emailController?.dispose();
    state.passwordController?.dispose();
  }

  /// Validates the full name field
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  /// Validates the nickname field
  String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nickname is required';
    }
    if (value.trim().length < 3) {
      return 'Nickname must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Nickname can only contain letters, numbers, and underscores';
    }
    return null;
  }

  /// Validates the email field
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates the password field
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  /// Toggles the terms agreement checkbox
  void toggleTermsAgreement() {
    state = state.copyWith(
      isTermsAgreed: !(state.isTermsAgreed ?? false),
    );
  }

  /// Creates a new user account
  Future<void> createAccount() async {
    if (!(state.isTermsAgreed ?? false)) {
      state = state.copyWith(
        errorMessage: 'Please agree to the terms and conditions',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // Simulate account creation API call
      await Future.delayed(const Duration(seconds: 2));

      final registrationModel = RegistrationModel(
        fullName: state.fullNameController?.text.trim(),
        nickname: state.nicknameController?.text.trim(),
        email: state.emailController?.text.trim(),
        password: state.passwordController?.text,
        isTermsAccepted: state.isTermsAgreed,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: true,
        registrationModel: registrationModel,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: false,
        errorMessage: 'Failed to create account. Please try again.',
      );
    }
  }

  /// Signs in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // Simulate Google sign in API call
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: false,
        errorMessage: 'Google sign in failed. Please try again.',
      );
    }
  }

  /// Signs in with Apple
  Future<void> signInWithApple() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // Simulate Apple sign in API call
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        isSuccess: false,
        errorMessage: 'Apple sign in failed. Please try again.',
      );
    }
  }
}
