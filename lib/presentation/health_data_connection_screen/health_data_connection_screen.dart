import 'package:flutter/material.dart';

// Assuming these are your project's custom imports.
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import 'notifier/health_data_connection_notifier.dart';

class HealthDataConnectionScreen extends ConsumerStatefulWidget {
  const HealthDataConnectionScreen({Key? key}) : super(key: key);

  @override
  HealthDataConnectionScreenState createState() =>
      HealthDataConnectionScreenState();
}

class HealthDataConnectionScreenState
    extends ConsumerState<HealthDataConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    // This layout creates the centered white card on a dark background.
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121212), // A dark background color
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // A good max width for mobile screens
            ),
            child: Container(
              margin: EdgeInsets.all(16.h),
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.h),
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(16.h),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 32.h),
                    _buildTitleAndDescription(),
                    SizedBox(height: 28.h),
                    _buildHealthAppsSection(),
                    SizedBox(height: 30.h),
                    _buildBenefitsSection(),
                    SizedBox(height: 32.h),
                    _buildPrivacyNote(),
                    SizedBox(height: 38.h),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget: App Logo and Name
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

  /// Section Widget: Main Title and Description
  Widget _buildTitleAndDescription() {
    return Column(
      children: [
        Text(
          'Connect Health Data',
          style: TextStyleHelper.instance.headline24BoldInter,
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            'Connect your health app to track your steps, distance, and activity automatically. WalkTalk uses this data to provide personalized insights and challenges.',
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.title16RegularInter.copyWith(
              color: appTheme.blue_gray_700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget: Health App Icons
  Widget _buildHealthAppsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // **FIXED** Aligning by text baseline to ensure all labels are perfectly inline.
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _buildHealthAppItem(
          iconPath: ImageConstant.imgIWhiteA70064x64,
          backgroundColor: appTheme.black_900,
          label: 'Health',
        ),
        SizedBox(width: 16.h),
        _buildHealthAppItem(
          iconPath: ImageConstant.imgI64x64,
          backgroundColor: appTheme.blue_A200,
          label: 'Fitness',
        ),
        SizedBox(width: 16.h),
        _buildHealthAppItem(
          iconPath: ImageConstant.imgI3,
          backgroundColor: appTheme.teal_A700,
          label: 'Samsung Health',
        ),
      ],
    );
  }

  /// Reusable Widget for a single health app item.
  Widget _buildHealthAppItem({
    required String iconPath,
    required Color backgroundColor,
    required String label,
  }) {
    // By giving each item a fixed width, we ensure the spacing between them is identical.
    return SizedBox(
      width: 90.h, // Adjust this width if needed, but it must be the same for all.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIconButton(
            iconPath: iconPath,
            backgroundColor: backgroundColor,
            size: 64.h,
            borderRadius: 12.h,
            padding: EdgeInsets.all(16.h),
            onTap: () {
              _onTapHealthApp();
            },
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyleHelper.instance.body14RegularInter,
            // Ensures text is centered if it wraps to a new line.
            textAlign: TextAlign.center,
            maxLines: 2, // Allow text to wrap if the label is very long.
          ),
        ],
      ),
    );
  }

  /// Section Widget: Benefits List
  Widget _buildBenefitsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.gray_50,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benefits of connecting:',
            style: TextStyleHelper.instance.title16SemiBoldInter,
          ),
          SizedBox(height: 16.h),
          _buildBenefitItem('Automatic step and activity tracking'),
          SizedBox(height: 12.h),
          _buildBenefitItem('Personalized fitness insights'),
          SizedBox(height: 12.h),
          _buildBenefitItem('Compete in challenges with friends'),
        ],
      ),
    );
  }

  /// Reusable Widget for a single benefit item.
  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrameTeal400,
          height: 16.h,
          width: 14.h,
        ),
        SizedBox(width: 12.h),
        // Expanded ensures the text wraps if it's too long
        Expanded(
          child: Text(
            text,
            style: TextStyleHelper.instance.title16RegularInter.copyWith(
              color: appTheme.blue_gray_700,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget: Privacy Note
  Widget _buildPrivacyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrameGray600,
          height: 12.h,
          width: 10.h,
          margin: EdgeInsets.only(top: 2.h),
        ),
        SizedBox(width: 8.h),
        Text(
          'Your health data is private and secure. We only access the data you allow.',
          style: TextStyleHelper.instance.body12RegularInter,
        ),
      ],
    );
  }

  /// Section Widget: Action Buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Connect Now',
          // Ensure this ImageConstant path is correct for your project.
          leftIcon: ImageConstant.imgIWhiteA70024x20,
          backgroundColor: appTheme.green_500,
          textColor: appTheme.white_A700,
          borderRadius: 12.h,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.h),
          onPressed: () {
            _onTapConnectNow();
          },
        ),
        SizedBox(height: 16.h),
        CustomButton(
          text: 'Skip for Now',
          backgroundColor: appTheme.white_A700,
          textColor: appTheme.blue_gray_700,
          borderColor: appTheme.blue_gray_100,
          borderWidth: 1.h,
          borderRadius: 12.h,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.h),
          onPressed: () {
            _onTapSkipForNow();
          },
        ),
      ],
    );
  }

  // --- Helper Functions ---
  void _onTapConnectNow() {
    ref.read(healthDataConnectionNotifier.notifier).connectHealthData();
  }

  void _onTapHealthApp() {
    ref.read(healthDataConnectionNotifier.notifier).selectHealthApp();
  }

  void _onTapSkipForNow() {
    NavigatorService.pushNamed(AppRoutes.profileScreen);
  }
}