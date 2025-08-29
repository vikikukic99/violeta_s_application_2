import '../../../core/app_export.dart';

/// This class is used in the [registration_screen] screen.

// ignore_for_file: must_be_immutable
class RegistrationModel extends Equatable {
  RegistrationModel({
    this.fullName,
    this.nickname,
    this.email,
    this.password,
    this.isTermsAccepted,
    this.id,
  }) {
    fullName = fullName ?? '';
    nickname = nickname ?? '';
    email = email ?? '';
    password = password ?? '';
    isTermsAccepted = isTermsAccepted ?? false;
    id = id ?? '';
  }

  String? fullName;
  String? nickname;
  String? email;
  String? password;
  bool? isTermsAccepted;
  String? id;

  RegistrationModel copyWith({
    String? fullName,
    String? nickname,
    String? email,
    String? password,
    bool? isTermsAccepted,
    String? id,
  }) {
    return RegistrationModel(
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        nickname,
        email,
        password,
        isTermsAccepted,
        id,
      ];
}
