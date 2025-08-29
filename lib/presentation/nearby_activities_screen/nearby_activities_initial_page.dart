import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/nearby_activities_notifier.dart';
import './widgets/activity_item_widget.dart';

class NearbyActivitiesInitialPage extends ConsumerStatefulWidget {
  const NearbyActivitiesInitialPage({Key? key}) : super(key: key);

  @override
  NearbyActivitiesInitialPageState createState() =>
      NearbyActivitiesInitialPageState();
}

class NearbyActivitiesInitialPageState
    extends ConsumerState<NearbyActivitiesInitialPage> {
  TextEditingController distanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    distanceController.text = '5km';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(nearbyActivitiesNotifier);

        return Scaffold(
          body: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: appTheme.gray_100,
            ),
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: _buildMainContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      decoration: BoxDecoration(
        color: appTheme.gray_100,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFrame,
                  height: 30.h,
                  width: 18.h,
                ),
                SizedBox(width: 8.h),
                Text(
                  'WalkTalk',
                  style: TextStyleHelper.instance.display50BoldPoppins
                      .copyWith(color: appTheme.green_500),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 44.h,
              width: 32.h,
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(16.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.color190000,
                    blurRadius: 15.h,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgIBlueGray800,
                height: 28.h,
                width: 16.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, NearbyActivitiesState state) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: appTheme.color190000,
            blurRadius: 15.h,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _buildHeaderSection(context),
          SizedBox(height: 20.h),
          _buildFilterSection(context, state),
          SizedBox(height: 20.h),
          Expanded(
            child: _buildActivitiesList(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nearby Activities',
                style: TextStyleHelper.instance.title20BoldPoppins,
              ),
              SizedBox(height: 4.h),
              Text(
                '40 activities within 15km',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.gray_600),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
          decoration: BoxDecoration(
            color: appTheme.colorE5FFFF,
            border: Border.all(
              color: appTheme.color190000,
              width: 1.h,
            ),
            borderRadius: BorderRadius.circular(18.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIcbaselineplus,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 8.h),
              Text(
                '5km',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.black_900),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(
      BuildContext context, NearbyActivitiesState state) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 2.h),
          decoration: BoxDecoration(
            color: appTheme.green_500,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Text(
            'All',
            style: TextStyleHelper.instance.body14RegularPoppins
                .copyWith(color: appTheme.white_A700),
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
          decoration: BoxDecoration(
            color: appTheme.gray_100,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIBlueGray80020x8,
                height: 20.h,
                width: 8.h,
              ),
              SizedBox(width: 4.h),
              Text(
                'Walking',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.blue_gray_800),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
          decoration: BoxDecoration(
            color: appTheme.gray_100,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIBlueGray80020x12,
                height: 20.h,
                width: 12.h,
              ),
              SizedBox(width: 4.h),
              Text(
                'Running',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.blue_gray_800),
              ),
            ],
          ),
        ),
        Spacer(),
        CustomImageView(
          imagePath: ImageConstant.imgSolarRefreshOutline,
          height: 24.h,
          width: 24.h,
        ),
      ],
    );
  }

  Widget _buildActivitiesList(
      BuildContext context, NearbyActivitiesState state) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return SizedBox(height: 12.h);
      },
      itemCount: state.nearbyActivitiesModel?.activityItemsList?.length ?? 0,
      itemBuilder: (context, index) {
        final activityModel =
            state.nearbyActivitiesModel?.activityItemsList?[index];
        return ActivityItemWidget(
          activityItemModel: activityModel!,
          onTapJoin: () {
            onTapJoin(context);
          },
        );
      },
    );
  }

  void onTapJoin(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.activityDetailScreen);
  }
}
