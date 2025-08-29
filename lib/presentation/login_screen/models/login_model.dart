import '../../../core/app_export.dart';

/// This class is used in the [login_screen] screen.

// ignore_for_file: must_be_immutable
class LoginModel extends Equatable {
  LoginModel({
    this.email,
    this.password,
    this.isRememberMe,
  }) {
    email = email ?? '';
    password = password ?? '';
    isRememberMe = isRememberMe ?? false;
  }

  String? email;
  String? password;
  bool? isRememberMe;

  LoginModel copyWith({
    String? email,
    String? password,
    bool? isRememberMe,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isRememberMe: isRememberMe ?? this.isRememberMe,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isRememberMe,
      ];
}
