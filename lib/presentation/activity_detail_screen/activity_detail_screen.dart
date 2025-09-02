import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.white_A700,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
                size: 28.h, color: appTheme.blue_gray_900),
            onPressed: () => NavigatorService.goBack(),
          ),
          title: Text(
            'Activity Details',
            style: TextStyleHelper.instance.title16SemiBoldPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert,
                  size: 22.h, color: appTheme.blue_gray_900),
              onPressed: () => _showOptionsMenu(context),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(height: 1.h, color: appTheme.blue_gray_100),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(16.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.color0C0000,
                  blurRadius: 8.h,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            padding: EdgeInsets.all(20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & description
                Text(
                  'Evening Walk',
                  style: TextStyleHelper.instance.title20BoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                SizedBox(height: 8.h),
                Text(
                  'A refreshing walk through Riverside Park with fellow nature enthusiasts.',
                  style: TextStyleHelper.instance.body14RegularPoppins
                      .copyWith(color: appTheme.blue_gray_600, height: 1.5),
                ),
                SizedBox(height: 20.h),

                // 2x2 Grid layout for info pills
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.h,
                  childAspectRatio: 2.2,
                  children: const [
                    _InfoPill(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date & Time',
                      value: 'Sun, Jul 14 • 7:30 AM',
                    ),
                    _InfoPill(
                      icon: Icons.access_time_outlined,
                      label: 'Duration',
                      value: '90 minutes',
                    ),
                    _InfoPill(
                      icon: Icons.group_outlined,
                      label: 'Participants',
                      value: '1 joined',
                    ),
                    _InfoPill(
                      icon: Icons.terrain_outlined,
                      label: 'Difficulty',
                      value: 'Easy',
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Host section
                Container(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray_50,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: CustomImageView(
                          imagePath: ImageConstant.imgDivWhiteA70024x22,
                          height: 48.h,
                          width: 48.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sarah Johnson',
                              style: TextStyleHelper
                                  .instance.title16SemiBoldPoppins
                                  .copyWith(color: appTheme.blue_gray_900),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Host • Walk Leader',
                              style: TextStyleHelper
                                  .instance.body12RegularPoppins
                                  .copyWith(color: appTheme.gray_600),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            NavigatorService.pushNamed(AppRoutes.profileScreen),
                        child: Text(
                          'View Profile',
                          style: TextStyleHelper.instance.body14MediumPoppins
                              .copyWith(color: appTheme.green_500),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Location section
                Text(
                  'Location',
                  style: TextStyleHelper.instance.title16SemiBoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Riverside Park, East Entrance',
                  style: TextStyleHelper.instance.body14MediumPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                SizedBox(height: 4.h),
                Text(
                  '123 River Road, Riverside, CA 92507',
                  style: TextStyleHelper.instance.body14RegularPoppins
                      .copyWith(color: appTheme.blue_gray_600),
                ),
                SizedBox(height: 16.h),

                // Get Directions Button
                GestureDetector(
                  onTap: () => _openDirections(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: appTheme.white_A700,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(color: appTheme.green_500, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions,
                            size: 20.h, color: appTheme.green_500),
                        SizedBox(width: 8.h),
                        Text(
                          'Get Directions',
                          style: TextStyleHelper.instance.title16MediumPoppins
                              .copyWith(color: appTheme.green_500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom action area
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              boxShadow: [
                BoxShadow(
                  color: appTheme.color0C0000,
                  blurRadius: 8.h,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Chat button
                GestureDetector(
                  onTap: () =>
                      NavigatorService.pushNamed(AppRoutes.chatListScreen),
                  child: Container(
                    width: 52.h,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: appTheme.white_A700,
                      shape: BoxShape.circle,
                      border: Border.all(color: appTheme.blue_gray_200),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 24.h,
                      color: appTheme.blue_gray_700,
                    ),
                  ),
                ),
                SizedBox(width: 16.h),

                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCancelDialog(context),
                    child: Container(
                      height: 52.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                      child: Text(
                        'Cancel this walk',
                        style: TextStyleHelper.instance.title16SemiBoldPoppins
                            .copyWith(color: appTheme.white_A700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Open directions in maps app
  Future<void> _openDirections() async {
    const String address =
        "Riverside Park, East Entrance, 123 River Road, Riverside, CA 92507";
    const String encodedAddress =
        "Riverside+Park,+East+Entrance,+123+River+Road,+Riverside,+CA+92507";

    final List<String> mapUrls = [
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
      'https://maps.apple.com/?q=$encodedAddress',
    ];

    for (String url in mapUrls) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // Fallback - show snackbar if no maps app available
    // This would need BuildContext, so we'd show a generic message
  }

  // Show options menu
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appTheme.white_A700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.h,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: appTheme.blue_gray_200,
                borderRadius: BorderRadius.circular(2.h),
              ),
            ),
            _OptionItem(
              icon: Icons.share,
              title: 'Share Activity',
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            _OptionItem(
              icon: Icons.report_outlined,
              title: 'Report Activity',
              onTap: () {
                Navigator.pop(context);
                // Implement report functionality
              },
            ),
            _OptionItem(
              icon: Icons.bookmark_border,
              title: 'Save Activity',
              onTap: () {
                Navigator.pop(context);
                // Implement save functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show cancel confirmation dialog
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appTheme.white_A700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        title: Text(
          'Cancel Activity',
          style: TextStyleHelper.instance.title16SemiBoldPoppins
              .copyWith(color: appTheme.blue_gray_900),
        ),
        content: Text(
          'Are you sure you want to cancel this walk? This action cannot be undone.',
          style: TextStyleHelper.instance.body14RegularPoppins
              .copyWith(color: appTheme.blue_gray_600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Activity',
              style: TextStyleHelper.instance.body14MediumPoppins
                  .copyWith(color: appTheme.blue_gray_600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement cancel activity logic here
              _cancelActivity(context);
            },
            child: Text(
              'Cancel Walk',
              style: TextStyleHelper.instance.body14MediumPoppins
                  .copyWith(color: const Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  // Handle activity cancellation
  void _cancelActivity(BuildContext context) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Walk has been cancelled successfully',
          style: TextStyleHelper.instance.body14MediumPoppins
              .copyWith(color: appTheme.white_A700),
        ),
        backgroundColor: appTheme.green_500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        margin: EdgeInsets.all(16.h),
      ),
    );

    // Navigate back after short delay
    Future.delayed(const Duration(seconds: 1), () {
      NavigatorService.goBack();
    });
  }
}

/* Helper Widgets */

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoPill({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.gray_50,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.blue_gray_100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.h,
                height: 24.h,
                decoration: BoxDecoration(
                  color: appTheme.green_500.withAlpha(38),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.h, color: appTheme.green_500),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: Text(
                  label,
                  style: TextStyleHelper.instance.body12RegularPoppins
                      .copyWith(color: appTheme.blue_gray_600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.blue_gray_900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _OptionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.h),
      leading: Container(
        width: 40.h,
        height: 40.h,
        decoration: BoxDecoration(
          color: appTheme.gray_50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.h, color: appTheme.blue_gray_700),
      ),
      title: Text(
        title,
        style: TextStyleHelper.instance.title16MediumPoppins
            .copyWith(color: appTheme.blue_gray_900),
      ),
      onTap: onTap,
    );
  }
}