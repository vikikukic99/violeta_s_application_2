import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/activity_item_model.dart';

class ActivityItemWidget extends StatelessWidget {
  final ActivityItemModel activityItemModel;
  final VoidCallback? onTapJoin;

  const ActivityItemWidget({
    Key? key,
    required this.activityItemModel,
    this.onTapJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(
          color: appTheme.gray_100,
          width: 1.h,
        ),
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.color0C0000,
            blurRadius: 2.h,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: activityItemModel.iconBackgroundColor ??
                      Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20.h),
                ),
                child: CustomImageView(
                  imagePath: activityItemModel.iconPath ?? '',
                  height: 24.h,
                  width: 24.h,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activityItemModel.title ?? '',
                      style: TextStyleHelper.instance.title16SemiBoldPoppins,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      activityItemModel.location ?? '',
                      style: TextStyleHelper.instance.body12RegularPoppins,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                decoration: BoxDecoration(
                  color: activityItemModel.statusBackgroundColor ??
                      Color(0x33FFD54F),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Text(
                  activityItemModel.status ?? '',
                  style: TextStyleHelper.instance.body12MediumPoppins.copyWith(
                      color: activityItemModel.statusTextColor ??
                          Color(0xFFFF8F00)),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(width: 16.h),
              CustomImageView(
                imagePath: activityItemModel.leaderImage ?? '',
                height: 24.h,
                width: 22.h,
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Text(
                  activityItemModel.leaderName ?? '',
                  style: TextStyleHelper.instance.body12RegularPoppins,
                ),
              ),
              GestureDetector(
                onTap: onTapJoin,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  decoration: BoxDecoration(
                    color: appTheme.green_500,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyleHelper.instance.body12RegularPoppins
                        .copyWith(color: appTheme.white_A700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
