import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/health_dashboard_model.dart';

class ConnectedServicesWidget extends StatelessWidget {
  final List<ConnectedServiceModel> services;
  final VoidCallback? onManageServices;
  final VoidCallback? onConnectService;

  const ConnectedServicesWidget({
    Key? key,
    required this.services,
    this.onManageServices,
    this.onConnectService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.h,
                    height: 32.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: appTheme.blue_50,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgDivBlueGray300,
                      height: 20.h,
                      width: 20.h,
                      color: appTheme.blue_A700,
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    'Connected Services',
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onManageServices,
                child: Text(
                  'Manage',
                  style: TextStyleHelper.instance.body14MediumPoppins
                      .copyWith(color: appTheme.green_500),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Services list or empty state
          if (services.isEmpty) ...[
            _EmptyServicesState(onConnectService: onConnectService),
          ] else ...[
            ...services.map((service) => _ServiceItemWidget(service: service)),
            SizedBox(height: 12.h),
            _ConnectMoreButton(onTap: onConnectService),
          ],
        ],
      ),
    );
  }
}

class _ServiceItemWidget extends StatelessWidget {
  final ConnectedServiceModel service;

  const _ServiceItemWidget({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Service icon
          Container(
            width: 40.h,
            height: 40.h,
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: service.backgroundColor,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: CustomImageView(
              imagePath: service.iconPath,
              height: 24.h,
              width: 24.h,
            ),
          ),
          SizedBox(width: 12.h),

          // Service info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.displayName,
                  style: TextStyleHelper.instance.body14MediumPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                SizedBox(height: 2.h),
                Text(
                  service.lastSyncAt != null
                      ? 'Last sync: ${_formatSyncTime(service.lastSyncAt!)}'
                      : 'Not synced yet',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),
              ],
            ),
          ),

          // Status indicator
          Container(
            width: 8.h,
            height: 8.h,
            decoration: BoxDecoration(
              color: service.isActive ? appTheme.green_500 : appTheme.gray_600,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSyncTime(DateTime syncTime) {
    final now = DateTime.now();
    final difference = now.difference(syncTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _EmptyServicesState extends StatelessWidget {
  final VoidCallback? onConnectService;

  const _EmptyServicesState({
    Key? key,
    this.onConnectService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.h,
          height: 64.h,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: appTheme.gray_100,
            borderRadius: BorderRadius.circular(32.h),
          ),
          child: CustomImageView(
            imagePath: ImageConstant.imgDivBlueGray300,
            height: 32.h,
            width: 32.h,
            color: appTheme.gray_600,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'No Connected Services',
          style: TextStyleHelper.instance.body14MediumPoppins
              .copyWith(color: appTheme.blue_gray_800),
        ),
        SizedBox(height: 8.h),
        Text(
          'Connect health apps to automatically\nsync your fitness data',
          textAlign: TextAlign.center,
          style: TextStyleHelper.instance.body12RegularInter
              .copyWith(color: appTheme.gray_600),
        ),
        SizedBox(height: 16.h),
        _ConnectMoreButton(onTap: onConnectService),
      ],
    );
  }
}

class _ConnectMoreButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ConnectMoreButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: appTheme.green_50,
          borderRadius: BorderRadius.circular(8.h),
          border: Border.all(color: appTheme.green_500.withAlpha(80)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgIcbaselineplus,
              height: 16.h,
              width: 16.h,
              color: appTheme.green_500,
            ),
            SizedBox(width: 8.h),
            Text(
              'Connect Service',
              style: TextStyleHelper.instance.body14MediumPoppins
                  .copyWith(color: appTheme.green_500),
            ),
          ],
        ),
      ),
    );
  }
}