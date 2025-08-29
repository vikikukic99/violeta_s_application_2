import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_edit_text.dart';
import 'notifier/privacy_settings_notifier.dart';

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  PrivacySettingsScreenState createState() => PrivacySettingsScreenState();
}

class PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(privacySettingsNotifier);

        return Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: appTheme.white_A700,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Column(
                    children: [
                      _buildScrollableContent(context),
                      SizedBox(height: 14.h)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildScrollableContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [_buildBlockedUsersSection(context)],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildBlockedUsersSection(BuildContext context) {
    return Column(
      children: [_buildSearchField(context), _buildBlockedUsersList(context)],
    );
  }

  /// Section Widget
  Widget _buildSearchField(BuildContext context) {
    return CustomEditText(
      hintText: 'Blocked Users',
      rightIcon: ImageConstant.imgProiconscancel,
      textColor: appTheme.blue_gray_900,
      fontSize: 18.fSize,
      fontWeight: FontWeight.w600,
      contentPadding: EdgeInsets.fromLTRB(16.h, 18.h, 32.h, 18.h),
    );
  }

  /// Section Widget
  Widget _buildBlockedUsersList(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 202.h,
      margin: EdgeInsets.only(top: 14.h),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: appTheme.gray_100,
                      width: 1.h,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.h,
                      height: 40.h,
                      child: Image.asset(
                        ImageConstant.imgDivWhiteA70024x22,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 6.h),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sarah\n',
                              style: TextStyleHelper.instance.title16MediumInter
                                  .copyWith(
                                      color: appTheme.blue_gray_900,
                                      height: 1.5),
                            ),
                            TextSpan(
                              text: 'Blocked on July 13, 2023',
                              style: TextStyleHelper.instance.body12RegularInter
                                  .copyWith(height: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 6.h),
                      padding: EdgeInsets.fromLTRB(14.h, 4.h, 14.h, 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.blue_gray_100_02,
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Text(
                        'Unblock',
                        style: TextStyleHelper.instance.body14MediumInter
                            .copyWith(color: appTheme.blue_gray_900),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 22.h),
                  padding: EdgeInsets.fromLTRB(14.h, 6.h, 14.h, 6.h),
                  decoration: BoxDecoration(
                    color: appTheme.indigo_A400,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    'Unblock',
                    style: TextStyleHelper.instance.body14MediumInter
                        .copyWith(color: appTheme.white_A700),
                  ),
                ),
              ),
              SizedBox(height: 38.h),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 22.h),
                  padding: EdgeInsets.fromLTRB(12.h, 4.h, 12.h, 4.h),
                  decoration: BoxDecoration(
                    color: appTheme.indigo_A400,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    'Unblock',
                    style: TextStyleHelper.instance.body14MediumPoppins
                        .copyWith(color: appTheme.white_A700),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.fromLTRB(60.h, 12.h, 12.h, 12.h),
                  child: Text(
                    'Pera',
                    style: TextStyleHelper.instance.title16MediumInter
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 48.h,
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.h),
                        ),
                        child: Image.asset(
                          ImageConstant.imgImg48x48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8.h),
                      Text(
                        'Mika',
                        style: TextStyleHelper.instance.title16MediumInter
                            .copyWith(color: appTheme.blue_gray_900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
