part of 'edit_profile_notifier.dart';

class EditProfileState extends Equatable {
  final TextEditingController? fullNameController;
  final TextEditingController? usernameController;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final EditProfileModel? editProfileModel;

  const EditProfileState({
    this.fullNameController,
    this.usernameController,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.editProfileModel,
  });

  @override
  List<Object?> get props => [
        fullNameController,
        usernameController,
        isLoading,
        isSuccess,
        errorMessage,
        editProfileModel,
      ];

  EditProfileState copyWith({
    TextEditingController? fullNameController,
    TextEditingController? usernameController,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    EditProfileModel? editProfileModel,
  }) {
    return EditProfileState(
      fullNameController: fullNameController ?? this.fullNameController,
      usernameController: usernameController ?? this.usernameController,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      editProfileModel: editProfileModel ?? this.editProfileModel,
    );
  }
}
