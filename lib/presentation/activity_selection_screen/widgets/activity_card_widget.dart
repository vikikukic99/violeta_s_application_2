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
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                color: selected ? appTheme.white_A700 : appTheme.gray_100,
                borderRadius: BorderRadius.circular(24.h),
              ),
              padding: EdgeInsets.all(10.h),
              child: CustomImageView(
                imagePath: activity.iconPath ?? '',
                fit: BoxFit.contain,
                color: selected ? appTheme.green_500 : appTheme.blue_gray_800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              activity.title ?? '',
              style: TextStyleHelper.instance.title16MediumInter.copyWith(
                color: selected ? appTheme.white_A700 : appTheme.blue_gray_800,
              ),
            )
          ],
        ),
      ),
    );
  }
}
