import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

/// Selectable activity card with clean glyph icons (no inner white frames).
class ActivityCardWidget extends StatelessWidget {
  const ActivityCardWidget({
    Key? key,
    required this.activity,
    this.onTap,
  }) : super(key: key);

  final dynamic activity;
  final VoidCallback? onTap;

  String _label(dynamic a) =>
      (a?.title ?? a?.name ?? a?.label ?? 'Activity') as String;

  String? _iconPath(dynamic a) => (a?.iconPath ?? a?.icon) as String?;

  bool _isSelected(dynamic a) =>
      (a?.isSelected ?? a?.selected ?? false) as bool;

  /// Map common activity names/asset names to frameless Material glyphs.
  IconData? _glyphFor(dynamic a) {
    final label = _label(a).toLowerCase().trim();
    final path = (_iconPath(a) ?? '').toLowerCase();

    bool has(String s) => label.contains(s) || path.contains(s);

    if (has('dog')) return Icons.pets_rounded;
    if (has('cycl') || has('bike')) return Icons.pedal_bike_rounded;  // cycling ✅
    if (has('run')) return Icons.directions_run_rounded;
    if (has('walk')) return Icons.directions_walk_rounded;

    return null; // unknown -> fallback to asset if provided
  }

  @override
  Widget build(BuildContext context) {
    final selected = _isSelected(activity);
    final label = _label(activity);
    final assetPath = _iconPath(activity);
    final glyph = _glyphFor(activity);

    final bg = selected ? appTheme.green_500 : appTheme.white_A700;
    final border = selected ? Colors.transparent : appTheme.blue_gray_100;
    final titleColor = selected ? appTheme.white_A700 : appTheme.blue_gray_900;
    final iconColor = selected ? appTheme.white_A700 : appTheme.blue_gray_700;

    return InkWell(
      borderRadius: BorderRadius.circular(16.h),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 18.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(color: border, width: 1.h),
          boxShadow: [
            if (!selected)
              BoxShadow(
                color: appTheme.color0C0000,
                blurRadius: 8.h,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show a clean Material glyph when we recognize the activity.
            if (glyph != null)
              Icon(glyph, size: 28.h, color: iconColor)
            else if (assetPath != null && assetPath.isNotEmpty)
              // Fallback to provided asset (tinted if vector).
              CustomImageView(
                imagePath: assetPath,
                height: 28.h,
                width: 28.h,
                color: iconColor,
              )
            else
              Icon(Icons.sports_handball_rounded, size: 28.h, color: iconColor),

            SizedBox(height: 10.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.title14MediumPoppins
                  .copyWith(color: titleColor),
            ),
          ],
        ),
      ),
    );
  }
}
