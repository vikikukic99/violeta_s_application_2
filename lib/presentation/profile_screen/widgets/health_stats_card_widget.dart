import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class HealthStatsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String goal;
  final double progress;
  final String icon;
  final Color backgroundColor;
  final Color progressColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const HealthStatsCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.goal,
    required this.progress,
    required this.icon,
    required this.backgroundColor,
    required this.progressColor,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  width: 32.h,
                  height: 32.h,
                  padding: EdgeInsets.all(6.h),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: CustomImageView(
                    imagePath: icon,
                    height: 20.h,
                    width: 20.h,
                    color: progressColor,
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyleHelper.instance.body14MediumPoppins
                            .copyWith(color: appTheme.blue_gray_800),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: TextStyleHelper.instance.body12RegularInter
                              .copyWith(color: appTheme.gray_600),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Progress bar
            Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: appTheme.gray_100,
                borderRadius: BorderRadius.circular(3.h),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(3.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Value and goal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyleHelper.instance.title20BoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                Text(
                  'Goal: $goal',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuickStatsRowWidget extends StatelessWidget {
  final String steps;
  final String calories;
  final String distance;
  final VoidCallback? onStepsTap;
  final VoidCallback? onCaloriesTap;
  final VoidCallback? onDistanceTap;

  const QuickStatsRowWidget({
    Key? key,
    required this.steps,
    required this.calories,
    required this.distance,
    this.onStepsTap,
    this.onCaloriesTap,
    this.onDistanceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickStatWidget(
            icon: ImageConstant.imgFrameGreen500,
            value: steps,
            label: 'Steps',
            backgroundColor: appTheme.green_50,
            iconColor: appTheme.green_500,
            onTap: onStepsTap,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: _QuickStatWidget(
            icon: ImageConstant.imgVectorAmber500,
            value: calories,
            label: 'Calories',
            backgroundColor: appTheme.yellow_50,
            iconColor: appTheme.amber_500,
            onTap: onCaloriesTap,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: _QuickStatWidget(
            icon: ImageConstant.imgFrameTeal400,
            value: distance,
            label: 'Distance',
            backgroundColor: appTheme.teal_50,
            iconColor: appTheme.teal_400,
            onTap: onDistanceTap,
          ),
        ),
      ],
    );
  }
}

class _QuickStatWidget extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _QuickStatWidget({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(color: appTheme.blue_gray_100),
        ),
        child: Column(
          children: [
            Container(
              width: 24.h,
              height: 24.h,
              padding: EdgeInsets.all(4.h),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6.h),
              ),
              child: CustomImageView(
                imagePath: icon,
                height: 16.h,
                width: 16.h,
                color: iconColor,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyleHelper.instance.title14SemiBoldPoppins
                  .copyWith(color: appTheme.blue_gray_900),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyleHelper.instance.body12RegularInter
                  .copyWith(color: appTheme.gray_600),
            ),
          ],
        ),
      ),
    );
  }
}