import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../privacy_settings_screen/privacy_settings_screen.dart';

class AppNavigationScreen extends ConsumerStatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
}

class AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    children: [
                      _buildScreenTitle(
                        context,
                        screenTitle: "Loading",
                        onTapScreenTitle: () =>
                            onTapScreenTitle(context, AppRoutes.splashScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Onboarding: Welcome",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.onboardingScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Sign up",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.registrationScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Onboarding: Choose Interests",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.activitySelectionScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Connect Health Data",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.healthDataConnectionScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Profile View",
                        onTapScreenTitle: () =>
                            onTapScreenTitle(context, AppRoutes.profileScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Edit Profile",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.editProfileScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Main",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.nearbyActivitiesScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Log in",
                        onTapScreenTitle: () =>
                            onTapScreenTitle(context, AppRoutes.loginScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Payment",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.paymentMethodsScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Blocked Users",
                        onTapScreenTitle: () =>
                            onTapDialogTitle(context, PrivacySettingsScreen()),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Group Chat View",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.chatConversationScreen),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Activity Detail",
                        onTapScreenTitle: () => onTapScreenTitle(
                            context, AppRoutes.activityDetailScreen),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title20RegularRoboto
                      .copyWith(color: Color(0XFF000000)),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0XFF343330),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1.h, thickness: 1.h, color: Color(0XFFD2D2D2)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(BuildContext context, String routeName) {
    NavigatorService.pushNamed(routeName);
  }

  /// Common click event for bottomsheet
  void onTapBottomSheetTitle(BuildContext context, Widget className) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return className;
      },
      isScrollControlled: true,
      backgroundColor: appTheme.transparentCustom,
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: className,
          backgroundColor: appTheme.transparentCustom,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
