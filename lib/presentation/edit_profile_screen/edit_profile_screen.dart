import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';
import './models/activity_preference_model.dart';
import 'notifier/edit_profile_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  File? _pickedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(editProfileNotifierProvider);
    nameController =
        TextEditingController(text: initialState.editProfileModel?.fullName);
    usernameController =
        TextEditingController(text: initialState.editProfileModel?.username);
    bioController =
        TextEditingController(text: initialState.editProfileModel?.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 32.0),
                _buildProfilePictureSection(context),
                const SizedBox(height: 40.0),
                _buildFormSection(),
                const SizedBox(height: 40.0),
                _buildFavoriteActivitiesSection(),
                const SizedBox(height: 40.0),
                _buildSaveChangesButton(),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: appTheme.whiteA700,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => onTapBackButton(context),
      ),
      centerTitle: true,
      title: Text("Edit Profile",
          style: TextStyleHelper.instance.titleMediumPoppins),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: appTheme.gray_200, height: 1.0),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: 112,
            width: 112,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: appTheme.whiteA700, width: 4),
                  ),
                  child: ClipOval(
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!,
                            fit: BoxFit.cover, height: 104, width: 104)
                        : CustomImageView(
                            imagePath: ImageConstant.imgImg104x104,
                            height: 104,
                            width: 104,
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => _showImagePicker(context),
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: appTheme.green_A700,
                        shape: BoxShape.circle,
                        border: Border.all(color: appTheme.whiteA700, width: 2),
                      ),
                      child: Icon(Icons.camera_alt,
                          color: appTheme.whiteA700, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showImagePicker(context),
          child: Text(
            "Change Picture",
            style: TextStyleHelper.instance.bodyMediumGreenA700.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: TextStyleHelper.instance.labelLargePoppins),
        const SizedBox(height: 8),
        CustomEditText(
          controller: nameController,
          hintText: "Enter your name",
          validator: (value) =>
              (value?.isEmpty ?? true) ? "Name cannot be empty" : null,
        ),
        const SizedBox(height: 24),
        Text("Username", style: TextStyleHelper.instance.labelLargePoppins),
        const SizedBox(height: 8),
        CustomEditText(
          controller: usernameController,
          hintText: "Enter your username",
          validator: (value) =>
              (value?.isEmpty ?? true) ? "Username cannot be empty" : null,
        ),
        const SizedBox(height: 24),
        Text("About", style: TextStyleHelper.instance.labelLargePoppins),
        const SizedBox(height: 8),
        CustomEditText(
          controller: bioController,
          hintText: "Tell us about yourself",
        ),
      ],
    );
  }

  Widget _buildFavoriteActivitiesSection() {
    final provider = ref.watch(editProfileNotifierProvider);
    final notifier = ref.read(editProfileNotifierProvider.notifier);
    final activities = provider.editProfileModel?.activityPreferences;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Favorite Activities",
            style: TextStyleHelper.instance.titleSmallPoppins),
        const SizedBox(height: 16),
        if (activities != null)
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3.2,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              ActivityPreferenceModel model = activities[index];

              return GestureDetector(
                onTap: () => notifier.toggleActivitySelection(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: model.isSelected!
                        ? appTheme.green100
                        : appTheme.gray_100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: model.isSelected!
                          ? appTheme.green_A700
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        model.icon,
                        size: 18,
                        color: model.isSelected!
                            ? appTheme.green_A700
                            : appTheme.gray700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        model.activityName!,
                        style:
                            TextStyleHelper.instance.bodyMediumGray700.copyWith(
                          color: model.isSelected!
                              ? appTheme.green_A700
                              : appTheme.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        else
          const Center(child: Text("No activities found.")),
      ],
    );
  }

  Widget _buildSaveChangesButton() {
    return CustomButton(
      text: "Save Changes",
      onPressed: onTapSaveChanges,
      backgroundColor: appTheme.indigo_A400,
      textColor: appTheme.whiteA700,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      selectedIndex: 2, // Profile tab is selected since this is profile-related
      onChanged: (index) => CustomBottomBar.handleNavigation(context, index),
    );
  }

  void onTapBackButton(BuildContext context) {
    Navigator.pop(context);
  }

  void onTapChangePicture(BuildContext context) {
    _showImagePicker(context);
  }

  void onTapSaveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(editProfileNotifierProvider.notifier);
      notifier.saveProfile(
        name: nameController.text,
        username: usernameController.text,
        bio: bioController.text,
      );
      if (_pickedImage != null) {
        print("Uploading new profile image...");
        // TODO: Add your image upload logic here
      }
      Navigator.pop(context);
    }
  }
}
