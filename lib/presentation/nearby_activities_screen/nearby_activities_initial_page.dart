import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/nearby_activities_notifier.dart';
import './widgets/activity_item_widget.dart';
import './models/activity_item_model.dart'; // <- for typed access in distance parser

class NearbyActivitiesInitialPage extends ConsumerStatefulWidget {
  const NearbyActivitiesInitialPage({Key? key}) : super(key: key);

  @override
  NearbyActivitiesInitialPageState createState() =>
      NearbyActivitiesInitialPageState();
}

class NearbyActivitiesInitialPageState
    extends ConsumerState<NearbyActivitiesInitialPage> {
  /// Selected radius in kilometers (filter)
  int _radiusKm = 5;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyActivitiesNotifier);

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(color: appTheme.gray_100),
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildMainContent(context, state)),
          ],
        ),
      ),
    );
  }

  // HEADER (logo + large notifications bell)
  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      color: appTheme.white_A700,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFrame,
                  height: 30.h,
                  width: 18.h,
                ),
                SizedBox(width: 8.h),
                Text(
                  'WalkTalk',
                  style: TextStyleHelper.instance.display50BoldPoppins
                      .copyWith(color: appTheme.green_500),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.h),
              onTap: _onNotificationsTap,
              child: Container(
                height: 48.h,
                width: 48.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appTheme.white_A700,
                  borderRadius: BorderRadius.circular(20.h),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.color190000,
                      blurRadius: 15.h,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 30.h,
                  color: appTheme.blue_gray_800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNotificationsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notifications tapped'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        backgroundColor: appTheme.blue_gray_800,
      ),
    );
  }

  // PAGE BODY
  Widget _buildMainContent(BuildContext context, NearbyActivitiesState state) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: appTheme.color190000,
            blurRadius: 15.h,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _buildHeaderSection(context, state),
          SizedBox(height: 20.h),
          _buildFilterSection(context, state),
          SizedBox(height: 20.h),
          Expanded(child: _buildActivitiesList(context, state)),
        ],
      ),
    );
  }

  // Title + distance chip
  Widget _buildHeaderSection(BuildContext context, NearbyActivitiesState state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nearby Activities',
                  style: TextStyleHelper.instance.title20BoldPoppins),
              SizedBox(height: 4.h),
              Text(
                'Within $_radiusKm km',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.gray_600),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: _showRadiusPicker,
          borderRadius: BorderRadius.circular(18.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
            decoration: BoxDecoration(
              color: appTheme.colorE5FFFF,
              border: Border.all(color: appTheme.color190000, width: 1.h),
              borderRadius: BorderRadius.circular(18.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.color190000,
                  blurRadius: 15.h,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgIcbaselineplus,
                  height: 20.h,
                  width: 20.h,
                ),
                SizedBox(width: 8.h),
                Text(
                  '${_radiusKm}km',
                  style: TextStyleHelper.instance.body14MediumPoppins
                      .copyWith(color: appTheme.black_900),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Category chips (scrollable)
  Widget _buildFilterSection(
      BuildContext context, NearbyActivitiesState state) {
    final selected = _selectedFilter(state);

    Widget chip({
      required String label,
      IconData? icon,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      final bg = isSelected ? appTheme.green_500 : appTheme.gray_100;
      final fg = isSelected ? appTheme.white_A700 : appTheme.blue_gray_800;

      return Padding(
        padding: EdgeInsets.only(right: 8.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.h),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18.h, color: fg),
                  SizedBox(width: 6.h),
                ],
                Text(
                  label,
                  style: TextStyleHelper.instance.body14RegularPoppins
                      .copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                chip(
                  label: 'All',
                  isSelected: selected == 'All',
                  onTap: () => ref
                      .read(nearbyActivitiesNotifier.notifier)
                      .selectFilter('All'),
                ),
                chip(
                  label: 'Walking',
                  icon: Icons.directions_walk_rounded,
                  isSelected: selected == 'Walking',
                  onTap: () => ref
                      .read(nearbyActivitiesNotifier.notifier)
                      .selectFilter('Walking'),
                ),
                chip(
                  label: 'Running',
                  icon: Icons.directions_run_rounded,
                  isSelected: selected == 'Running',
                  onTap: () => ref
                      .read(nearbyActivitiesNotifier.notifier)
                      .selectFilter('Running'),
                ),
                chip(
                  label: 'Cycling',
                  icon: Icons.pedal_bike_rounded,
                  isSelected: selected == 'Cycling',
                  onTap: () => ref
                      .read(nearbyActivitiesNotifier.notifier)
                      .selectFilter('Cycling'),
                ),
                chip(
                  label: 'Dog Walking',
                  icon: Icons.pets_rounded,
                  isSelected: selected == 'Dog Walking',
                  onTap: () => ref
                      .read(nearbyActivitiesNotifier.notifier)
                      .selectFilter('Dog Walking'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.h),
        CustomImageView(
          imagePath: ImageConstant.imgSolarRefreshOutline,
          height: 24.h,
          width: 24.h,
        ),
      ],
    );
  }

  // List filtered by distance AND category
  Widget _buildActivitiesList(
      BuildContext context, NearbyActivitiesState state) {
    final all = state.nearbyActivitiesModel?.activityItemsList ?? const [];
    final selected = _selectedFilter(state);

    final filtered = <ActivityItemModel>[];
    for (final m in all) {
      // 1) Distance filter — unknown distances are treated as too far
      final km = _extractDistanceKm(m);
      final within = (km ?? double.infinity) <= _radiusKm;

      // 2) Category filter
      final cat = ((m as dynamic).category ?? 'Walking').toString().toLowerCase();
      final matchesCategory =
          (selected == 'All') ? true : cat == selected.toLowerCase();

      if (within && matchesCategory) filtered.add(m);
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final activityModel = filtered[index];
        return ActivityItemWidget(
          activityItemModel: activityModel,
          onTapJoin: () => onTapJoin(context),
        );
      },
    );
  }

  void onTapJoin(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.activityDetailScreen);
  }

  // Helpers
  String _selectedFilter(NearbyActivitiesState s) {
    try {
      final v1 = s.selectedFilter;
      if (v1.isNotEmpty) return v1;
    } catch (_) {}
    try {
      final v2 = s.nearbyActivitiesModel?.selectedFilter;
      if (v2 is String && v2.isNotEmpty) return v2;
    } catch (_) {}
    return 'All';
  }

  Future<void> _showRadiusPicker() async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: appTheme.white_A700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
      ),
      builder: (ctx) {
        Widget item(int value) => ListTile(
              title: Text(
                '$value km',
                style: TextStyleHelper.instance.title16RegularPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              trailing:
                  _radiusKm == value ? Icon(Icons.check, color: appTheme.green_500) : null,
              onTap: () => Navigator.pop(ctx, value),
            );

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 44.h,
                height: 4.h,
                decoration: BoxDecoration(
                  color: appTheme.blue_gray_100,
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
              SizedBox(height: 8.h),
              item(5),
              item(10),
              item(15),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );

    if (chosen != null && chosen != _radiusKm) {
      setState(() => _radiusKm = chosen);
    }
  }

  /// Robust distance extraction:
  /// 1) If model exposes `distanceKm` (num), use it.
  /// 2) Else parse from `location` string like "• 7.5 km away".
  double? _extractDistanceKm(dynamic m) {
    try {
      // Prefer a numeric property if your model has it
      final v = (m as dynamic).distanceKm;
      if (v is num) return v.toDouble();
    } catch (_) {}

    // Fallback: parse from ActivityItemModel.location
    if (m is ActivityItemModel) {
      final text = m.location ?? '';
      final match =
          RegExp(r'([0-9]+(?:\.[0-9]+)?)\s*km', caseSensitive: false).firstMatch(text);
      if (match != null) return double.tryParse(match.group(1)!);
    }

    return null; // unknown -> treated as too far
  }
}
