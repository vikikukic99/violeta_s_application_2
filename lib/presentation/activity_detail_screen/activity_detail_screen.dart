import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import 'notifier/activity_detail_notifier.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({Key? key}) : super(key: key);

  @override
  ActivityDetailScreenState createState() => ActivityDetailScreenState();
}

class ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAppBar(context),
                    _buildActivityContent(context),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray_100,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgButtonBlueGray700,
            height: 40.h,
            width: 40.h,
            onTap: () {
              onTapBackButton(context);
            },
          ),
          Text(
            'Activity Details',
            style: TextStyleHelper.instance.title18SemiBoldInter
                .copyWith(height: 1.22),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgButtonBlueGray70040x20,
            height: 40.h,
            width: 40.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildActivityContent(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 16.h,
        right: 16.h,
        bottom: 64.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivityCard(context),
          _buildLocationSection(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildActivityCard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.h),
          topRight: Radius.circular(24.h),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.color0C0000,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          Text(
            'Evening Walk',
            style: TextStyleHelper.instance.headline24BoldInter
                .copyWith(height: 1.25),
          ),
          SizedBox(height: 4.h),
          Text(
            'A refreshing walk through Riverside Park',
            style: TextStyleHelper.instance.title16RegularInter
                .copyWith(color: appTheme.blue_gray_700, height: 1.25),
          ),
          Text(
            'with fellow nature enthusiasts.',
            style: TextStyleHelper.instance.title16RegularInter
                .copyWith(color: appTheme.blue_gray_700, height: 1.25),
          ),
          SizedBox(height: 20.h),
          _buildActivityDetails(context),
          SizedBox(height: 12.h),
          _buildSecondaryDetails(context),
          SizedBox(height: 28.h),
          _buildHostSection(context),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildActivityDetails(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40.h,
          width: 28.h,
          decoration: BoxDecoration(
            color: appTheme.colorE5194F,
            borderRadius: BorderRadius.circular(14.h),
          ),
          child: Center(
            child: CustomImageView(
              imagePath: ImageConstant.imgIGreen50024x14,
              height: 24.h,
              width: 14.h,
            ),
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date & Time',
                style: TextStyleHelper.instance.body12RegularInter
                    .copyWith(height: 1.25),
              ),
              SizedBox(height: 2.h),
              Text(
                'Sun, Jul 14 • 7:30 AM',
                style: TextStyleHelper.instance.title16MediumInter
                    .copyWith(color: appTheme.blue_gray_900, height: 1.5),
              ),
            ],
          ),
        ),
        CustomIconButton(
          iconPath: ImageConstant.imgIGreen50040x40,
          backgroundColor: appTheme.colorE5194F,
          size: 40.h,
          borderRadius: 20.h,
          padding: EdgeInsets.all(8.h),
        ),
        SizedBox(width: 12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              'Duration',
              style: TextStyleHelper.instance.body12RegularInter
                  .copyWith(height: 1.25),
            ),
            Text(
              '90 minutes',
              style: TextStyleHelper.instance.title16MediumInter
                  .copyWith(color: appTheme.blue_gray_900, height: 1.25),
            ),
          ],
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSecondaryDetails(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          iconPath: ImageConstant.imgI4,
          backgroundColor: appTheme.colorE5194F,
          size: 40.h,
          borderRadius: 20.h,
          padding: EdgeInsets.all(8.h),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participants',
                style: TextStyleHelper.instance.body12RegularInter
                    .copyWith(height: 1.25),
              ),
              SizedBox(height: 2.h),
              Text(
                '1 joined',
                style: TextStyleHelper.instance.title16MediumInter
                    .copyWith(color: appTheme.blue_gray_900, height: 1.25),
              ),
            ],
          ),
        ),
        CustomIconButton(
          iconPath: ImageConstant.imgI5,
          backgroundColor: appTheme.colorE5194F,
          size: 40.h,
          borderRadius: 20.h,
          padding: EdgeInsets.all(8.h),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Difficulty',
                style: TextStyleHelper.instance.body12RegularInter
                    .copyWith(height: 1.25),
              ),
              SizedBox(height: 2.h),
              Text(
                'Easy',
                style: TextStyleHelper.instance.title16MediumInter
                    .copyWith(color: appTheme.blue_gray_900, height: 1.25),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildHostSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: appTheme.gray_50,
        borderRadius: BorderRadius.circular(12.h),
      ),
      padding: EdgeInsets.all(12.h),
      child: Row(
        children: [
          SizedBox(width: 12.h),
          CustomImageView(
            imagePath: ImageConstant.imgDivWhiteA70048x48,
            height: 48.h,
            width: 48.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Johnson',
                  style: TextStyleHelper.instance.title16SemiBoldInter
                      .copyWith(height: 1.25),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Host • Walk Leader',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(height: 1.25),
                ),
              ],
            ),
          ),
          Text(
            'View Profile',
            style: TextStyleHelper.instance.body14MediumInter
                .copyWith(color: appTheme.green_500, height: 1.21),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            'Location',
            style: TextStyleHelper.instance.title18SemiBoldInter
                .copyWith(height: 1.22),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            'Riverside Park, East Entrance',
            style: TextStyleHelper.instance.title16RegularInter
                .copyWith(color: appTheme.blue_gray_700, height: 1.25),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            '123 River Road, Riverside, CA 92507',
            style: TextStyleHelper.instance.title16RegularInter
                .copyWith(color: appTheme.blue_gray_700, height: 1.25),
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 8.h),
          decoration: BoxDecoration(
            color: appTheme.gray_100,
            borderRadius: BorderRadius.circular(12.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIGreen50024x16,
                height: 24.h,
                width: 16.h,
              ),
              SizedBox(width: 8.h),
              Text(
                'Get Directions',
                style: TextStyleHelper.instance.title16MediumInter
                    .copyWith(color: appTheme.blue_gray_800, height: 1.25),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
      ),
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          CustomIconButton(
            iconPath: ImageConstant.imgIBlueGray80048x48,
            backgroundColor: appTheme.gray_100,
            size: 48.h,
            borderRadius: 24.h,
            padding: EdgeInsets.all(12.h),
            onTap: () {
              onTapChatButton(context);
            },
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: CustomButton(
              text: 'Cancel this walk',
              backgroundColor: appTheme.deep_orange_A700,
              textColor: appTheme.white_A700,
              fontSize: 16.fSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              borderRadius: 12.h,
              padding: EdgeInsets.symmetric(
                horizontal: 30.h,
                vertical: 12.h,
              ),
              onPressed: () {
                onTapCancelButton(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates back to the previous screen.
  void onTapBackButton(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigates to the chat conversation screen.
  void onTapChatButton(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.chatConversationScreen);
  }

  /// Handles cancel button tap
  void onTapCancelButton(BuildContext context) {
    // Handle cancel walk action
    ref.read(activityDetailNotifierProvider.notifier).cancelWalk();
  }
}
