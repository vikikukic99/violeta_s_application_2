import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomAppBar - A reusable app bar component with logo, title and profile icon
 * 
 * Features:
 * - Customizable background color
 * - Optional logo image and title text
 * - Profile icon with tap functionality
 * - Responsive design using SizeUtils
 * - Implements PreferredSizeWidget for proper AppBar integration
 * 
 * @param backgroundColor - Background color of the app bar
 * @param logoImage - Path to the logo image asset
 * @param title - Main title text to display
 * @param titleColor - Color for the title text
 * @param profileIcon - Path to the profile icon asset
 * @param onProfileTap - Callback function when profile icon is tapped
 * @param height - Height of the app bar
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.backgroundColor,
    this.logoImage,
    this.title,
    this.titleColor,
    this.profileIcon,
    this.onProfileTap,
    this.height,
  }) : super(key: key);

  /// Background color of the app bar
  final Color? backgroundColor;

  /// Path to the logo image asset
  final String? logoImage;

  /// Main title text to display
  final String? title;

  /// Color for the title text
  final Color? titleColor;

  /// Path to the profile icon asset
  final String? profileIcon;

  /// Callback function when profile icon is tapped
  final VoidCallback? onProfileTap;

  /// Height of the app bar
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 84.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Color(0xFFF3F4F6),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 84.h,
      title: Row(
        children: [
          if (logoImage != null) ...[
            CustomImageView(
              imagePath: logoImage!,
              height: 30.h,
              width: 18.h,
            ),
            SizedBox(width: 8.h),
          ],
          if (title != null)
            Text(
              title!,
              style: TextStyleHelper.instance.display50BoldPoppins.copyWith(
                  color: titleColor ?? Color(0xFF4CAF50), height: 1.5),
            ),
        ],
      ),
      actions: [
        if (profileIcon != null)
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              margin: EdgeInsets.only(right: 20.h),
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: appTheme.whiteCustom,
                borderRadius: BorderRadius.circular(16.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.color190000,
                    offset: Offset(0, 10),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: CustomImageView(
                imagePath: profileIcon!,
                height: 28.h,
                width: 16.h,
              ),
            ),
          ),
      ],
    );
  }
}
