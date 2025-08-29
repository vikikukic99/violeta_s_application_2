import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/activity_chip_model.dart';

class ActivityChipWidget extends StatelessWidget {
  final ActivityChipModel activityChip;

  const ActivityChipWidget({
    Key? key,
    required this.activityChip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: activityChip.backgroundColor ?? Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: activityChip.icon ?? '',
            height: 16.h,
            width: 20.h,
          ),
          SizedBox(width: 4.h),
          Text(
            activityChip.title ?? '',
            style: TextStyleHelper.instance.body12MediumInter.copyWith(
                color: activityChip.textColor ?? Color(0xFF2563EB),
                height: 1.25),
          ),
        ],
      ),
    );
  }
}
