import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/activity_model.dart';

class ActivityCardWidget extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onTap;

  const ActivityCardWidget({
    Key? key,
    required this.activity,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected = activity.isSelected ?? false;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? appTheme.green_500 : appTheme.white_A700,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: selected ? appTheme.green_500 : appTheme.gray_200,
            width: 2.h, // Enhanced border width for better frame visibility
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? appTheme.green_500.withAlpha(51)
                  : appTheme.black_900.withAlpha(13),
              blurRadius: selected ? 8.h : 4.h,
              offset: Offset(0, selected ? 4.h : 2.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                color: selected ? appTheme.white_A700 : appTheme.gray_50,
                borderRadius: BorderRadius.circular(
                    12.h), // More rounded for better aesthetics
                border: Border.all(
                  color: selected
                      ? appTheme.green_500.withAlpha(77)
                      : appTheme.gray_200,
                  width: 1.5.h, // Enhanced frame inside icons
                ),
                boxShadow: [
                  BoxShadow(
                    color: selected
                        ? appTheme.green_500.withAlpha(26)
                        : appTheme.black_900.withAlpha(8),
                    blurRadius: 2.h,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: activity.iconPath ?? '',
                  height: 24.h,
                  width: 24.h,
                  color: selected ? appTheme.green_600 : appTheme.blue_gray_700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 12.h), // Increased spacing for better balance
            Text(
              activity.title ?? '',
              style: TextStyleHelper.instance.body14MediumInter.copyWith(
                color: selected ? appTheme.white_A700 : appTheme.blue_gray_800,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}