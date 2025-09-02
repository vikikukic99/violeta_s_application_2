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
    final Color pillBg =
        activityItemModel.statusBackgroundColor ?? const Color(0x33FFD54F);
    final Color pillFg = activityItemModel.statusTextColor ?? const Color(0xFFFF8F00);
    final Color iconBg =
        activityItemModel.iconBackgroundColor ?? const Color(0xFF4CAF50);

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(color: appTheme.gray_100, width: 1.h),
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.color0C0000,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: category icon + title/location + status pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CLEAN ICON: Material glyph on a solid circle (no stroked image)
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(20.h),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _iconForCategory(activityItemModel.category),
                  size: 20.h,
                  color: appTheme.white_A700,
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
                  color: pillBg,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Text(
                  activityItemModel.status ?? '',
                  style: TextStyleHelper.instance.body12MediumPoppins
                      .copyWith(color: pillFg),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Bottom row: leader avatar + name + Join
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
                  padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
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

  /// Map normalized category to a clean Material icon.
  IconData _iconForCategory(String? category) {
    final c = (category ?? 'Walking').toLowerCase();
    if (c.contains('run')) return Icons.directions_run_rounded;
    if (c.contains('cycl')) return Icons.pedal_bike_rounded;
    if (c.contains('dog')) return Icons.pets_rounded;
    // default
    return Icons.directions_walk_rounded;
  }
}
