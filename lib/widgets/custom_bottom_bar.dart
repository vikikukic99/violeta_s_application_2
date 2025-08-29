import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A customizable bottom navigation bar component
 * 
 * This widget creates a bottom navigation bar with support for multiple items,
 * each containing an icon and text label. Supports active/inactive states with
 * different styling and navigation routing.
 * 
 * @param bottomBarItemList - List of navigation items to display
 * @param selectedIndex - Currently selected item index (default: 0)
 * @param onChanged - Callback function when an item is tapped, returns the index
 * @param backgroundColor - Background color of the bottom bar
 * @param padding - Internal padding of the bottom bar
 * @param height - Height of the bottom bar
 */
class CustomBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex,
    this.backgroundColor,
    this.padding,
    this.height,
  }) : super(key: key);

  /// List of bottom bar items with their properties
  final List<CustomBottomBarItem> bottomBarItemList;

  /// Current selected index of the bottom bar
  final int? selectedIndex;

  /// Callback function triggered when a bottom bar item is tapped
  final Function(int) onChanged;

  /// Background color of the bottom bar
  final Color? backgroundColor;

  /// Internal padding of the bottom bar
  final EdgeInsetsGeometry? padding;

  /// Height of the bottom bar
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 84.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 84.h,
      width: double.infinity,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 70.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? appTheme.whiteCustom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(bottomBarItemList.length, (index) {
          final isSelected = (selectedIndex ?? 0) == index;
          final item = bottomBarItemList[index];

          return InkWell(
            onTap: () => onChanged(index),
            child: _buildBottomBarItem(item, isSelected),
          );
        }),
      ),
    );
  }

  /// Builds individual bottom bar item widget
  Widget _buildBottomBarItem(CustomBottomBarItem item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImageView(
          imagePath: item.iconPath,
          height: isSelected ? 30.h : 16.h,
          width: isSelected ? 18.h : 14.h,
        ),
        SizedBox(height: isSelected ? 10.h : 14.h),
        Text(
          item.title,
          style: TextStyleHelper.instance.body12Inter.copyWith(
              color: isSelected ? Color(0xFF4CAF50) : appTheme.blue_gray_300,
              height: 1.25),
        ),
      ],
    );
  }
}

/**
 * CustomBottomBarItem - Data model for bottom navigation bar items
 * 
 * Contains all necessary information for displaying a navigation item
 * including icon, title, and routing information.
 */
class CustomBottomBarItem {
  const CustomBottomBarItem({
    required this.iconPath,
    required this.title,
    required this.routeName,
  });

  /// Path to the icon image (SVG or other formats)
  final String iconPath;

  /// Text label displayed below the icon
  final String title;

  /// Route name for navigation purposes
  final String routeName;
}
