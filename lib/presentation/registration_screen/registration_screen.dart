import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/registration_notifier.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,
        body: Form(
          key: _formKey,
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(registrationNotifierProvider);

              ref.listen<RegistrationState>(
                registrationNotifierProvider,
                (previous, current) {
                  // Modified: Added null safety handling for nullable boolean comparisons
                  if (!(previous?.isSubmitted ?? true) &&
                      (current.isSubmitted ?? false)) {
                    if (current.isSuccess ?? false) {
                      NavigatorService.pushNamed(
                          AppRoutes.activitySelectionScreen);
                    } else if (current.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(current.errorMessage ?? '')),
                      );
                    }
                  }
                },
              );

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 30.h,
                  left: 22.h,
                  right: 22.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    _buildHeader(),
                    SizedBox(height: 26.h),
                    _buildTitle(),
                    SizedBox(height: 4.h),
                    _buildSubtitle(),
                    SizedBox(height: 26.h),
                    _buildFullNameField(state),
                    SizedBox(height: 30.h),
                    _buildNicknameField(state),
                    SizedBox(height: 30.h),
                    _buildEmailField(state),
                    SizedBox(height: 30.h),
                    _buildPasswordField(state),
                    SizedBox(height: 6.h),
                    _buildPasswordHint(),
                    SizedBox(height: 26.h),
                    _buildTermsAgreement(state),
                    SizedBox(height: 16.h),
                    _buildCreateAccountButton(state),
                    SizedBox(height: 12.h),
                    _buildDivider(),
                    SizedBox(height: 16.h),
                    _buildSocialButtons(),
                    SizedBox(height: 14.h),
                    _buildLoginLink(),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrame,
          height: 30.h,
          width: 18.h,
        ),
        SizedBox(width: 8.h),
        Text(
          'WalkTalk',
          style: TextStyleHelper.instance.headline24BoldPoppins,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Create your account',
      style: TextStyleHelper.instance.headline24BoldPoppins
          .copyWith(color: appTheme.blue_gray_900),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Join WalkTalk and connect with fellow walkers!',
      style: TextStyleHelper.instance.title16RegularPoppins
          .copyWith(color: appTheme.blue_gray_700),
    );
  }

  Widget _buildFullNameField(RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: TextStyleHelper.instance.body14MediumPoppins
              .copyWith(color: appTheme.blue_gray_900),
        ),
        SizedBox(height: 4.h),
        CustomEditText(
          controller: state.fullNameController,
          hintText: 'Enter your name',
          leftIcon: ImageConstant.imgDiv,
          validator:
              ref.read(registrationNotifierProvider.notifier).validateFullName,
        ),
      ],
    );
  }

  Widget _buildNicknameField(RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Nickname  ',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              TextSpan(
                text: '*',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.red_A700),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        CustomEditText(
          controller: state.nicknameController,
          hintText: 'Enter your nickname',
          leftIcon: ImageConstant.imgDiv,
          rightIcon: ImageConstant.imgWeuiatoutlined,
          validator:
              ref.read(registrationNotifierProvider.notifier).validateNickname,
        ),
      ],
    );
  }

  Widget _buildEmailField(RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Email Address  ',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              TextSpan(
                text: '*',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.red_A700),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        CustomEditText(
          controller: state.emailController,
          hintText: 'Enter your email',
          inputType: TextInputType.emailAddress,
          leftIcon: ImageConstant.imgDivBlueGray300,
          rightIcon: ImageConstant.imgMaterialsymbolslightattachemailoutline,
          validator:
              ref.read(registrationNotifierProvider.notifier).validateEmail,
        ),
      ],
    );
  }

  Widget _buildPasswordField(RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Password   ',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              TextSpan(
                text: '*',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.red_A700),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        CustomEditText(
          controller: state.passwordController,
          hintText: 'Create a password',
          isPassword: true,
          leftIcon: ImageConstant.imgDivBlueGray30050x26,
          rightIcon:
              ImageConstant.imgMaterialsymbolslightvisibilityoffoutlinerounded,
          validator:
              ref.read(registrationNotifierProvider.notifier).validatePassword,
        ),
      ],
    );
  }

  Widget _buildPasswordHint() {
    return Text(
      'Password must be at least 8 characters',
      style: TextStyleHelper.instance.body12RegularPoppins,
    );
  }

  Widget _buildTermsAgreement(RegistrationState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          child: Checkbox(
            value: state.isTermsAgreed ?? false,
            onChanged: (value) {
              ref
                  .read(registrationNotifierProvider.notifier)
                  .toggleTermsAgreement();
            },
            activeColor: appTheme.green_500,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    'I agree to the ',
                    style: TextStyleHelper.instance.body14RegularPoppins
                        .copyWith(color: appTheme.blue_gray_700),
                  ),
                  Text(
                    'Terms of Service',
                    style: TextStyleHelper.instance.body14RegularPoppins
                        .copyWith(color: appTheme.green_500),
                  ),
                  Text(
                    ' and ',
                    style: TextStyleHelper.instance.body14RegularPoppins
                        .copyWith(color: appTheme.blue_gray_700),
                  ),
                  Text(
                    'Privacy',
                    style: TextStyleHelper.instance.body14MediumPoppins
                        .copyWith(color: appTheme.green_500),
                  ),
                ],
              ),
              Text(
                'Policy',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.green_500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(RegistrationState state) {
    return CustomButton(
      text: 'Create Account',
      backgroundColor: appTheme.green_500,
      textColor: appTheme.whiteCustom,
      rightIconWidget: Icon(
        Icons.arrow_forward_rounded,
        color: appTheme.whiteCustom,
        size: 20.h,
      ),
      isEnabled: !(state.isLoading ?? false),
      onPressed: () {
        // Validate form first
        if (_formKey.currentState!.validate()) {
          // Check if terms are agreed
          if (!(state.isTermsAgreed ?? false)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please agree to the terms and conditions')),
            );
            return;
          }
          
          // Store form data in session storage before redirecting
          final userData = {
            'fullName': state.fullNameController?.text.trim() ?? '',
            'nickname': state.nicknameController?.text.trim() ?? '',
            'email': state.emailController?.text.trim() ?? '',
          };
          
          // Store in browser's session storage
          html.window.sessionStorage['registration_data'] = 
              jsonEncode(userData);
          
          // Redirect to Replit Auth for account creation
          html.window.location.href = '/api/login';
        }
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: appTheme.blue_gray_100,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h),
          child: Text(
            'or continue with',
            style: TextStyleHelper.instance.body14RegularPoppins
                .copyWith(color: appTheme.gray_600),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            color: appTheme.blue_gray_100,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Google',
            backgroundColor: appTheme.whiteCustom,
            textColor: appTheme.blue_gray_900,
            borderColor: appTheme.blue_gray_100,
            leftIcon: ImageConstant.imgFrameBlueGray900,
            onPressed: () {
              // Redirect to Replit Auth (supports Google login)
              html.window.location.href = '/api/login';
            },
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: CustomButton(
            text: 'Apple',
            backgroundColor: appTheme.whiteCustom,
            textColor: appTheme.blue_gray_900,
            borderColor: appTheme.blue_gray_100,
            leftIcon: ImageConstant.imgFrameBlueGray90018x12,
            onPressed: () {
              // Redirect to Replit Auth (supports Apple login)
              html.window.location.href = '/api/login';
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: GestureDetector(
        onTap: () {
          // Redirect to Replit Auth login
          html.window.location.href = '/api/login';
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already have an account?',
                style: TextStyleHelper.instance.title16RegularPoppins
                    .copyWith(color: appTheme.blue_gray_700),
              ),
              TextSpan(
                text: '  Log In ',
                style: TextStyleHelper.instance.title16MediumPoppins
                    .copyWith(color: appTheme.green_500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}