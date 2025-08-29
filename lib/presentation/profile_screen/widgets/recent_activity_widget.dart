import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../models/recent_activity_model.dart';

class RecentActivityWidget extends StatelessWidget {
  final RecentActivityModel activity;

  const RecentActivityWidget({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          CustomIconButton(
            iconPath: activity.icon ?? ImageConstant.imgVectorBlueA700,
            backgroundColor:
                activity.iconBackgroundColor ?? appTheme.blue_50_01,
            size: 32.h,
            borderRadius: 16.h,
            padding: EdgeInsets.all(4.h),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title ?? 'Cycling Night',
                  style: TextStyleHelper.instance.body14SemiBoldInter
                      .copyWith(color: appTheme.blue_gray_900, height: 1.21),
                ),
                Text(
                  activity.subtitle ?? 'Organized • 2 days ago',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(height: 1.25),
                ),
              ],
            ),
          ),
          if (activity.status?.isNotEmpty == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
              decoration: BoxDecoration(
                color: activity.statusBackgroundColor ?? appTheme.green_50,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: Text(
                activity.status!,
                style: TextStyleHelper.instance.body12MediumInter.copyWith(
                    color: activity.statusTextColor ?? appTheme.green_700,
                    height: 1.25),
              ),
            ),
        ],
      ),
    );
  }
}
