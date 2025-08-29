import 'package:flutter/material.dart';
import '../models/login_model.dart';
import '../../../core/app_export.dart';

final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    LoginState(
      loginModel: LoginModel(),
    ),
  ),
);

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(LoginState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      isLoading: false,
      isLoginSuccess: false,
    );
  }

  String? validateEmail(String? value) {
    if (value?.isEmpty == true) {
      return 'Email is required';
    }
    if (!(value?.contains('@') == true)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty == true) {
      return 'Password is required';
    }
    if ((value?.length ?? 0) < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void loginUser() {
    state = state.copyWith(isLoading: true);

    // Simulate login process
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      state = state.copyWith(
        isLoading: false,
        isLoginSuccess: true,
      );

      // Clear form fields
      state.emailController?.clear();
      state.passwordController?.clear();
    });
  }

  void loginWithGoogle() {
    state = state.copyWith(isLoading: true);

    // Simulate Google login
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;

      state = state.copyWith(
        isLoading: false,
        isLoginSuccess: true,
      );
    });
  }

  void loginWithApple() {
    state = state.copyWith(isLoading: true);

    // Simulate Apple login
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;

      state = state.copyWith(
        isLoading: false,
        isLoginSuccess: true,
      );
    });
  }

  @override
  void dispose() {
    state.emailController?.dispose();
    state.passwordController?.dispose();
    super.dispose();
  }
}

class LoginState {
  final LoginModel? loginModel;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isLoading;
  final bool isLoginSuccess;

  const LoginState({
    this.loginModel,
    this.emailController,
    this.passwordController,
    this.isLoading = false,
    this.isLoginSuccess = false,
  });

  LoginState copyWith({
    LoginModel? loginModel,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? isLoading,
    bool? isLoginSuccess,
  }) {
    return LoginState(
      loginModel: loginModel ?? this.loginModel,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
    );
  }
}