diff --git a/lib/widgets/custom_app_bar.dart b/lib/widgets/custom_app_bar.dart
index 34976ec7ade61be5bdd3e02c4adf87736a75b0da..a9b556d66b0047e7d3ae13ae90108f788ad3fa74 100644
--- a/lib/widgets/custom_app_bar.dart
+++ b/lib/widgets/custom_app_bar.dart
@@ -1,90 +1,102 @@
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
+ * - Optional back button
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
+ * @param showBackButton - Whether to display a back arrow
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
+    this.showBackButton = false,
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
 
+  /// Whether to show a back button on the leading side
+  final bool showBackButton;
+
   @override
   Size get preferredSize => Size.fromHeight(height ?? 84.h);
 
   @override
   Widget build(BuildContext context) {
     return AppBar(
       backgroundColor: backgroundColor ?? Color(0xFFF3F4F6),
       elevation: 0,
-      automaticallyImplyLeading: false,
+      automaticallyImplyLeading: showBackButton,
+      leading: showBackButton
+          ? IconButton(
+              icon: const Icon(Icons.arrow_back),
+              onPressed: () => Navigator.pop(context),
+            )
+          : null,
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
