import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/login_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700_01,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(22.h),
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoSection(context),
                  _buildTitleSection(context),
                  _buildFormSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget - Logo
  Widget _buildLogoSection(BuildContext context) {
    return Container(
      height: 80.h,
      width: 80.h,
      decoration: BoxDecoration(
        color: appTheme.indigo_A400,
        borderRadius: BorderRadius.circular(40.h),
      ),
      child: Center(
        child: CustomImageView(
          imagePath: ImageConstant.imgIWhiteA700,
          height: 36.h,
          width: 18.h,
        ),
      ),
    );
  }

  /// Section Widget - Title
  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Text(
          'WalkTalk',
          style: TextStyleHelper.instance.headline30BoldInter,
        ),
        SizedBox(height: 14.h),
        Text(
          'Connect through walking',
          style: TextStyleHelper.instance.title16RegularInter
              .copyWith(color: appTheme.blue_gray_700),
        ),
      ],
    );
  }

  /// Section Widget - Form
  Widget _buildFormSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(loginNotifierProvider);
        final notifier = ref.read(loginNotifierProvider.notifier);

        return Container(
          margin: EdgeInsets.only(top: 46.h),
          child: Column(
            children: [
              CustomEditText(
                controller: state.emailController,
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
                borderColor: appTheme.blue_gray_900,
                borderRadius: 12.h,
                contentPadding: EdgeInsets.all(16.h),
                validator: notifier.validateEmail,
              ),
              SizedBox(height: 16.h),
              CustomEditText(
                controller: state.passwordController,
                hintText: 'Password',
                isPassword: true,
                borderColor: appTheme.blue_gray_900,
                backgroundColor: appTheme.color33FFFF,
                borderRadius: 12.h,
                contentPadding: EdgeInsets.all(16.h),
                validator: notifier.validatePassword,
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'Log in',
                backgroundColor: appTheme.green_500,
                textColor: appTheme.whiteCustom,
                fontSize: 16.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                borderRadius: 12.h,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.h),
                onPressed: () => _onTapLogin(context),
              ),
              SizedBox(height: 16.h),
              Text(
                'Don\'t have an account?',
                style: TextStyleHelper.instance.title16RegularInter
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => _onTapCreateAccount(context),
                child: Text(
                  'Create Account',
                  style: TextStyleHelper.instance.title16SemiBoldInter
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 16.h),
              _buildDividerSection(context),
              SizedBox(height: 16.h),
              _buildSocialButtonsSection(context),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget - Divider
  Widget _buildDividerSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: appTheme.blue_gray_100,
          ),
        ),
        SizedBox(width: 12.h),
        Text(
          'or continue with',
          style: TextStyleHelper.instance.body14RegularPoppins
              .copyWith(color: appTheme.gray_600),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Container(
            height: 1.h,
            color: appTheme.blue_gray_100,
          ),
        ),
      ],
    );
  }

  /// Section Widget - Social Buttons
  Widget _buildSocialButtonsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Google',
            leftIcon: ImageConstant.imgFrameBlueGray900,
            backgroundColor: appTheme.whiteCustom,
            textColor: appTheme.blue_gray_900,
            borderColor: appTheme.blue_gray_100,
            borderRadius: 8.h,
            fontSize: 16.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.h),
            onPressed: () => _onTapGoogleLogin(context),
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: CustomButton(
            text: 'Apple',
            leftIcon: ImageConstant.imgFrameBlueGray90018x12,
            backgroundColor: appTheme.whiteCustom,
            textColor: appTheme.blue_gray_900,
            borderColor: appTheme.blue_gray_100,
            borderRadius: 8.h,
            fontSize: 16.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.h),
            onPressed: () => _onTapAppleLogin(context),
          ),
        ),
      ],
    );
  }

  /// Login button tap
  void _onTapLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginNotifierProvider.notifier).loginUser();

      // Listen for login success
      ref.listen(
        loginNotifierProvider,
        (previous, current) {
          if (current.isLoginSuccess) {
            NavigatorService.pushNamedAndRemoveUntil(
                AppRoutes.activitySelectionScreen);
          }
        },
      );
    }
  }

  /// Create account tap
  void _onTapCreateAccount(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.registrationScreen);
  }

  /// Google login tap
  void _onTapGoogleLogin(BuildContext context) {
    ref.read(loginNotifierProvider.notifier).loginWithGoogle();
  }

  /// Apple login tap
  void _onTapAppleLogin(BuildContext context) {
    ref.read(loginNotifierProvider.notifier).loginWithApple();
  }
}