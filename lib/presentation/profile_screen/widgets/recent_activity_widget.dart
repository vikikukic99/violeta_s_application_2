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
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.blue_gray_100),
      ),
      child: Row(
        children: [
          CustomIconButton(
            iconPath: activity.icon ?? '',
            backgroundColor: activity.iconBackgroundColor,
            size: 40.h,
            borderRadius: 20.h,
            padding: EdgeInsets.all(8.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.title ?? '',
                      style: TextStyleHelper.instance.body14SemiBoldInter
                          .copyWith(color: appTheme.blue_gray_900),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: activity.statusBackgroundColor,
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: Text(
                        activity.status ?? '',
                        style: TextStyleHelper.instance.body12MediumInter
                            .copyWith(color: activity.statusTextColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '${activity.joinedCount} • ${activity.location}',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.blue_gray_700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
