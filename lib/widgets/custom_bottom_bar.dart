import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A standardized bottom navigation bar component
 * 
 * This widget creates a consistent bottom navigation bar across all screens
 * matching the Figma design specifications with proper styling, icons, and navigation.
 * 
 * @param selectedIndex - Currently selected item index (0: Chat, 1: WalkTalk, 2: Profile)
 * @param onChanged - Callback function when an item is tapped, returns the index
 */
class CustomBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBottomBar({
    Key? key,
    this.selectedIndex = 0,
    required this.onChanged,
  }) : super(key: key);

  /// Current selected index of the bottom bar (0: Chat, 1: WalkTalk, 2: Profile)
  final int selectedIndex;

  /// Callback function triggered when a bottom bar item is tapped
  final Function(int) onChanged;

  @override
  Size get preferredSize => Size.fromHeight(84.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border(
          top: BorderSide(color: appTheme.blue_gray_100, width: 1.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBottomBarItem(
            iconPath: ImageConstant.imgNavChat,
            title: 'Chat',
            index: 0,
            isSelected: selectedIndex == 0,
          ),
          _buildBottomBarItem(
            iconPath: ImageConstant.imgFrame,
            title: 'WalkTalk',
            index: 1,
            isSelected: selectedIndex == 1,
          ),
          _buildBottomBarItem(
            iconPath: ImageConstant.imgNavProfile,
            title: 'Profile',
            index: 2,
            isSelected: selectedIndex == 2,
          ),
        ],
      ),
    );
  }

  /// Builds individual bottom bar item widget with consistent styling
  Widget _buildBottomBarItem({
    required String iconPath,
    required String title,
    required int index,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onChanged(index),
      borderRadius: BorderRadius.circular(8.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageView(
              imagePath: iconPath,
              height: isSelected ? 30.h : 16.h,
              width: isSelected ? 18.h : 14.h,
              color: isSelected ? appTheme.green_500 : appTheme.blue_gray_300,
            ),
            SizedBox(height: isSelected ? 10.h : 14.h),
            Text(
              title,
              style: TextStyleHelper.instance.body12Inter.copyWith(
                color: isSelected ? appTheme.green_500 : appTheme.blue_gray_300,
                height: 1.25,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to handle navigation based on selected index
  static void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.nearbyActivitiesScreen,
          routePredicate: false,
          arguments: {'tab': 0}, // Navigate to Chat tab
        );
        break;
      case 1:
        NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.nearbyActivitiesScreen,
          routePredicate: false,
          arguments: {'tab': 1}, // Navigate to WalkTalk tab
        );
        break;
      case 2:
        NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.nearbyActivitiesScreen,
          routePredicate: false,
          arguments: {'tab': 2}, // Navigate to Profile tab
        );
        break;
    }
  }
}

/**
 * CustomBottomBarItem - Data model for bottom navigation bar items (Legacy - kept for compatibility)
 * 
 * @deprecated Use the new standardized CustomBottomBar instead
 */
class CustomBottomBarItem {
  const CustomBottomBarItem({
    required this.iconPath,
    required this.title,
    required this.routeName,
  });

  final String iconPath;
  final String title;
  final String routeName;
}