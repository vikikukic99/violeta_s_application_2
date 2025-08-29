import 'package:flutter/material.dart';
import 'package:violeta_s_application_2/core/app_export.dart';
import 'package:violeta_s_application_2/widgets/app_bar/appbar_leading_image.dart';
import 'package:violeta_s_application_2/widgets/app_bar/appbar_title.dart';
import 'package:violeta_s_application_2/widgets/app_bar/appbar_trailing_image.dart';
import 'package:violeta_s_application_2/widgets/custom_app_bar.dart';
import 'package:violeta_s_application_2/widgets/custom_bottom_bar.dart';
import 'package:violeta_s_application_2/widgets/custom_button.dart';
import 'package:violeta_s_application_2/widgets/custom_icon_button.dart';
import 'models/activity_chip_model.dart';
import 'models/profile_model.dart';
import 'notifier/profile_notifier.dart';
import 'widgets/activity_chip_widget.dart';
import 'widgets/recent_activity_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 24.h,
                      right: 24.h,
                      bottom: 5.v,
                    ),
                    child: Column(
                      children: [
                        _buildProfileHeaderSection(context),
                        SizedBox(height: 34.v),
                        _buildAboutSection(context),
                        SizedBox(height: 30.v),
                        _buildFavoriteActivitiesSection(context),
                        SizedBox(height: 38.v),
                        _buildRecentActivitiesSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 48.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgButtonBlueGray800,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 12.v,
          bottom: 12.v,
        ),
        onTap: () {
          onTapBackButton(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "lbl_profile".tr,
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgButtonBlueGray80040x20,
          margin: EdgeInsets.symmetric(
            horizontal: 22.h,
            vertical: 8.v,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildProfileHeaderSection(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Column(children: [
        SizedBox(
            height: 112.v,
            width: 112.h,
            child: Stack(alignment: Alignment.bottomRight, children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 112.v,
                      width: 112.h,
                      decoration: BoxDecoration(
                          color: appTheme.blueGray100,
                          borderRadius: BorderRadius.circular(56.h),
                          border: Border.all(
                              color: appTheme.whiteA700, width: 4.h)))),
              CustomIconButton(
                  height: 28.adaptSize,
                  width: 28.adaptSize,
                  padding: EdgeInsets.all(7.h),
                  decoration: IconButtonStyleHelper.fillPrimary,
                  alignment: Alignment.bottomRight,
                  child: CustomImageView(
                      imagePath: ImageConstant.imgVectorWhiteA700))
            ])),
        SizedBox(height: 14.v),
        Text("lbl_sarah_johnson".tr, style: theme.textTheme.titleLarge),
        SizedBox(height: 6.v),
        Text("lbl_sarahjwalk".tr, style: CustomTextStyles.bodyMediumGray600),
        SizedBox(height: 16.v),
        CustomButton(
            height: 40.v,
            width: 124.h,
            text: "lbl_edit_profile".tr,
            leftIcon: Container(
                margin: EdgeInsets.only(right: 8.h),
                child: CustomImageView(
                    imagePath: ImageConstant.imgIWhiteA70020x14,
                    height: 20.v,
                    width: 14.h)),
            buttonStyle: CustomButtonStyles.fillPrimary,
            buttonTextStyle: CustomTextStyles.titleSmallWhiteA700)
      ]);
    });
  }

  /// Section Widget
  Widget _buildAboutSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("lbl_about".tr, style: CustomTextStyles.titleSmallPoppins),
      SizedBox(height: 16.v),
      SizedBox(
          width: 322.h,
          child: Text("msg_hiking_enthusiast".tr,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyMediumBluegray700
                  .copyWith(height: 1.64)))
    ]);
  }

  /// Section Widget
  Widget _buildFavoriteActivitiesSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("msg_favorite_activities".tr,
          style: CustomTextStyles.titleSmallPoppins),
      SizedBox(height: 14.v),
      Consumer(builder: (context, ref, _) {
        return Wrap(
            runSpacing: 8.v,
            spacing: 8.h,
            children: List<Widget>.generate(
                ref
                        .watch(profileNotifier)
                        .profileModelObj
                        ?.activityChipList
                        .length ??
                    0, (index) {
              ActivityChipModel model = ref
                      .watch(profileNotifier)
                      .profileModelObj
                      ?.activityChipList[index] ??
                  ActivityChipModel();
              return ActivityChipWidget(model);
            }));
      })
    ]);
  }

  /// Section Widget
  Widget _buildRecentActivitiesSection(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("lbl_recent_activities".tr,
            style: CustomTextStyles.titleSmallPoppins),
        Padding(
            padding: EdgeInsets.only(bottom: 3.v),
            child: Text("lbl_view_all".tr,
                style: CustomTextStyles.labelLargePrimary))
      ]),
      SizedBox(height: 18.v),
      Consumer(builder: (context, ref, _) {
        return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 12.v);
            },
            itemCount: ref
                    .watch(profileNotifier)
                    .profileModelObj
                    ?.recentActivityList
                    .length ??
                0,
            itemBuilder: (context, index) {
              RecentActivityModel model = ref
                      .watch(profileNotifier)
                      .profileModelObj
                      ?.recentActivityList[index] ??
                  RecentActivityModel();
              return RecentActivityWidget(model);
            });
      })
    ]);
  }

  /// Section Widget
  Widget _buildBottomNavigationBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      NavigatorService.pushNamed(getCurrentRoute(type));
    });
  }

  /// Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Chat:
        return AppRoutes.nearbyActivitiesInitialPage;
      case BottomBarEnum.Walktalk:
        return AppRoutes.nearbyActivitiesInitialPage;
      case BottomBarEnum.Profile:
        return AppRoutes.profileScreen;
      default:
        return "/";
    }
  }

  /// Navigates back to the previous screen.
  onTapBackButton(BuildContext context) {
    NavigatorService.goBack();
  }
}
