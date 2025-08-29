import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFEEF2FF),
                appTheme.white_A700,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      children: [
                        _buildStatusBar(),
                        SizedBox(height: 52.h),
                        _buildAppLogo(),
                        SizedBox(height: 8.h),
                        _buildAppTitle(),
                        SizedBox(height: 28.h),
                        _buildSubtitle(),
                        SizedBox(height: 28.h),
                        _buildMainImage(),
                        SizedBox(height: 28.h),
                        _buildPageIndicator(),
                        SizedBox(height: 112.h),
                        _buildSkipText(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildGetStartedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              children: [
                Container(
                  width: 20.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray900,
                    height: 16.h,
                    width: 18.h,
                  ),
                ),
                SizedBox(width: 8.h),
                Container(
                  width: 20.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray90014x20,
                    height: 14.h,
                    width: 20.h,
                  ),
                ),
                SizedBox(width: 8.h),
                Container(
                  width: 18.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray90010x18,
                    height: 10.h,
                    width: 18.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 104.h,
      height: 104.h,
      child: Stack(
        children: [
          Container(
            width: 96.h,
            height: 96.h,
            margin: EdgeInsets.only(right: 8.h),
            padding: EdgeInsets.all(28.h),
            decoration: BoxDecoration(
              color: appTheme.indigo_A400,
              borderRadius: BorderRadius.circular(48.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.color190000,
                  offset: Offset(0, 10),
                  blurRadius: 15,
                ),
              ],
            ),
            child: CustomImageView(
              imagePath: ImageConstant.imgVectorWhiteA700,
              height: 36.h,
              width: 22.h,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 40.h,
              height: 40.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: appTheme.green_500,
                borderRadius: BorderRadius.circular(20.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.color190000,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgVectorWhiteA70014x16,
                height: 14.h,
                width: 16.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'WalkTalk',
      style:
          TextStyleHelper.instance.display36BoldPoppins.copyWith(height: 1.11),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Track your active lifestyle',
      style:
          TextStyleHelper.instance.title18RegularPoppins.copyWith(height: 1.5),
    );
  }

  Widget _buildMainImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomImageView(
        imagePath: ImageConstant.img,
        height: 350.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.indigo_A400,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.blue_gray_100,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.blue_gray_100,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipText() {
    return Text(
      'Skip for now',
      style: TextStyleHelper.instance.body14RegularPoppins
          .copyWith(color: appTheme.gray_600, height: 1.43),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      width: 390.h,
      padding: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: appTheme.green_500,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.color190000,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            onTapGetStarted();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: TextStyleHelper.instance.title16SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700, height: 1.5),
              ),
              SizedBox(width: 6.h),
              CustomImageView(
                imagePath: ImageConstant.imgVectorWhiteA70012x14,
                height: 12.h,
                width: 14.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapGetStarted() {
    NavigatorService.pushNamed(AppRoutes.registrationScreen);
  }
}
