import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/profile_notifier.dart';
import './notifier/health_dashboard_notifier.dart';
import './models/health_dashboard_model.dart';
import './widgets/activity_chip_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/health_stats_card_widget.dart';
import './widgets/connected_services_widget.dart';
import './widgets/weekly_progress_chart_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key, this.showLocalBottomBar = true})
      : super(key: key);

  final bool showLocalBottomBar;

  void _safeBack(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    if (canPop) {
      NavigatorService.goBack();
    } else {
      NavigatorService.pushNamed(AppRoutes.nearbyActivitiesScreen);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);
    final healthState = ref.watch(healthDashboardNotifierProvider);
    final profile = state.profileModel;
    final chips = state.activityChips ?? [];
    final recent = state.recentActivities ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,

        // HEADER
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.white_A700,
          centerTitle: true,
          toolbarHeight: 64.h,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.chevron_left,
                color: appTheme.blue_gray_900, size: 28.h),
            onPressed: () => _safeBack(context),
          ),
          title: Text(
            'Profile',
            style: TextStyleHelper.instance.title20SemiBoldPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          actions: [
            IconButton(
              tooltip: 'More',
              icon: Icon(Icons.more_vert,
                  color: appTheme.blue_gray_900, size: 20.h),
              onPressed: () =>
                  NavigatorService.pushNamed(AppRoutes.editProfileScreen),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(height: 1.h, color: appTheme.blue_gray_100),
          ),
        ),

        // BODY
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120.h,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: appTheme.white_A700, width: 4.h),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(31),
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageView(
                      imagePath:
                          profile?.profileImage ?? ImageConstant.imgImg104x104,
                      height: 120.h,
                      width: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Name & handle
              Align(
                alignment: Alignment.center,
                child: Text(
                  profile?.userName ?? 'Sarah Johnson',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.headline24BoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  profile?.userHandle ?? '@sarahjwalk',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title16RegularPoppins
                      .copyWith(color: appTheme.gray_600),
                ),
              ),

              // Edit Profile
              SizedBox(height: 16.h),
              Center(
                child: CustomButton(
                  text: 'Edit Profile',
                  onPressed: () =>
                      NavigatorService.pushNamed(AppRoutes.editProfileScreen),
                  backgroundColor: appTheme.green_500,
                  textColor: appTheme.white_A700,
                  leftIcon: ImageConstant.imgFrameGray600,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.h),
                  borderRadius: 22.h,
                ),
              ),

              // About
              SizedBox(height: 24.h),
              Text(
                'About',
                style: TextStyleHelper.instance.title20SemiBoldPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              SizedBox(height: 8.h),
              Text(
                profile?.aboutText ??
                    'Hiking enthusiast and nature lover. I enjoy organizing group walks '
                        'and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.blue_gray_800, height: 1.5),
                textAlign: TextAlign.left,
              ),

              // Health Dashboard
              SizedBox(height: 32.h),
              _buildHealthDashboardSection(context, ref, healthState),

              // Favorite Activities
              SizedBox(height: 24.h),
              Text(
                'Favorite Activities',
                style: TextStyleHelper.instance.title20SemiBoldPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              SizedBox(height: 12.h),
              if (chips.isNotEmpty)
                Wrap(
                  spacing: 12.h,
                  runSpacing: 12.h,
                  children: chips
                      .map((chip) => ActivityChipWidget(activityChip: chip))
                      .toList(),
                )
              else
                Text(
                  'No activities yet.',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),

              // Recent Activities
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activities',
                    style: TextStyleHelper.instance.title20SemiBoldPoppins
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigatorService.pushNamed(
                          AppRoutes.nearbyActivitiesScreen);
                    },
                    child: Text(
                      'View All',
                      style: TextStyleHelper.instance.body14MediumPoppins
                          .copyWith(color: appTheme.green_500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (recent.isNotEmpty)
                ...recent
                    .map((activity) => RecentActivityWidget(activity: activity))
                    .toList()
              else
                Text(
                  'No recent activities.',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),

              SizedBox(height: 24.h),
            ],
          ),
        ),

        // Conditionally show bottom navigation bar
        bottomNavigationBar: showLocalBottomBar
            ? CustomBottomBar(
                selectedIndex: 2, // Profile is selected
                onChanged: (index) =>
                    CustomBottomBar.handleNavigation(context, index),
              )
            : null,
      ),
    );
  }

  Widget _buildHealthDashboardSection(BuildContext context, WidgetRef ref, HealthDashboardState healthState) {
    final healthNotifier = ref.read(healthDashboardNotifierProvider.notifier);
    final dashboard = healthState.healthDashboard;

    if (dashboard.isLoading) {
      return _buildHealthLoadingState();
    }

    if (dashboard.error != null) {
      return _buildHealthErrorState(dashboard.error!, () {
        healthNotifier.loadHealthDashboard();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Dashboard',
              style: TextStyleHelper.instance.title20SemiBoldPoppins
                  .copyWith(color: appTheme.blue_gray_900),
            ),
            GestureDetector(
              onTap: () {
                NavigatorService.pushNamed(AppRoutes.healthDataConnectionScreen);
              },
              child: Text(
                'Manage',
                style: TextStyleHelper.instance.body14MediumPoppins
                    .copyWith(color: appTheme.green_500),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Quick stats row
        if (dashboard.todayStats != null)
          QuickStatsRowWidget(
            steps: healthNotifier.getFormattedSteps(),
            calories: healthNotifier.getFormattedCalories(),
            distance: healthNotifier.getFormattedDistance(),
            onStepsTap: () => _showManualEntryDialog(context, ref, 'steps'),
            onCaloriesTap: () => _showManualEntryDialog(context, ref, 'calories'),
            onDistanceTap: () => _showManualEntryDialog(context, ref, 'distance'),
          ),
        SizedBox(height: 16.h),

        // Main health stats cards
        if (dashboard.todayStats != null) ...[
          Row(
            children: [
              Expanded(
                child: HealthStatsCardWidget(
                  title: 'Steps',
                  value: dashboard.todayStats!.steps.toString(),
                  goal: dashboard.todayStats!.stepsGoal.toString(),
                  progress: dashboard.todayStats!.stepsProgress,
                  icon: ImageConstant.imgFrameGreen500,
                  backgroundColor: appTheme.green_50,
                  progressColor: appTheme.green_500,
                  subtitle: 'Today',
                  onTap: () => _showManualEntryDialog(context, ref, 'steps'),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: HealthStatsCardWidget(
                  title: 'Calories',
                  value: dashboard.todayStats!.calories.toString(),
                  goal: dashboard.todayStats!.caloriesGoal.toString(),
                  progress: dashboard.todayStats!.caloriesProgress,
                  icon: ImageConstant.imgVectorAmber500,
                  backgroundColor: appTheme.yellow_50,
                  progressColor: appTheme.amber_500,
                  subtitle: 'Burned',
                  onTap: () => _showManualEntryDialog(context, ref, 'calories'),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Expanded(
                child: HealthStatsCardWidget(
                  title: 'Active Minutes',
                  value: dashboard.todayStats!.activeMinutes.toString(),
                  goal: dashboard.todayStats!.activeMinutesGoal.toString(),
                  progress: dashboard.todayStats!.activeMinutesProgress,
                  icon: ImageConstant.imgFrameTeal400,
                  backgroundColor: appTheme.teal_50,
                  progressColor: appTheme.teal_400,
                  subtitle: 'Today',
                  onTap: () => _showManualEntryDialog(context, ref, 'activeMinutes'),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: HealthStatsCardWidget(
                  title: 'Distance',
                  value: '${dashboard.todayStats!.distance.toStringAsFixed(1)} km',
                  goal: 'No goal set',
                  progress: 0.0,
                  icon: ImageConstant.imgFrameBlueGray900,
                  backgroundColor: appTheme.blue_gray_50,
                  progressColor: appTheme.blue_gray_800,
                  subtitle: 'Today',
                  onTap: () => _showManualEntryDialog(context, ref, 'distance'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],

        // Weekly progress chart
        if (dashboard.weeklyData != null && dashboard.weeklyData!.isNotEmpty)
          WeeklyProgressChartWidget(
            weeklyData: dashboard.weeklyData!,
            selectedMetric: healthState.selectedMetric,
            onMetricChanged: (metric) {
              healthNotifier.changeSelectedMetric(metric);
            },
            onViewDetails: () {
              // Navigate to detailed health analytics screen
              // NavigatorService.pushNamed(AppRoutes.healthAnalyticsScreen);
            },
          ),
        SizedBox(height: 16.h),

        // Connected services
        ConnectedServicesWidget(
          services: dashboard.connectedServices ?? [],
          onManageServices: () {
            NavigatorService.pushNamed(AppRoutes.healthDataConnectionScreen);
          },
          onConnectService: () {
            NavigatorService.pushNamed(AppRoutes.healthDataConnectionScreen);
          },
        ),
      ],
    );
  }

  Widget _buildHealthLoadingState() {
    return Container(
      padding: EdgeInsets.all(24.h),
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
        children: [
          CircularProgressIndicator(
            color: appTheme.green_500,
            strokeWidth: 2.h,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading health data...',
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.blue_gray_800),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthErrorState(String error, VoidCallback onRetry) {
    return Container(
      padding: EdgeInsets.all(24.h),
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
        children: [
          Icon(
            Icons.error_outline,
            color: appTheme.red_500,
            size: 48.h,
          ),
          SizedBox(height: 16.h),
          Text(
            'Failed to load health data',
            style: TextStyleHelper.instance.title16SemiBoldPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(color: appTheme.gray_600),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Retry',
            onPressed: onRetry,
            backgroundColor: appTheme.green_500,
            textColor: appTheme.white_A700,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
            borderRadius: 8.h,
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context, WidgetRef ref, String dataType) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _ManualEntryDialog(
          dataType: dataType,
          onSave: (value) async {
            final healthNotifier = ref.read(healthDashboardNotifierProvider.notifier);
            final today = DateTime.now();
            
            // Create updated daily activity based on data type
            final currentStats = ref.read(healthDashboardNotifierProvider).healthDashboard.todayStats;
            
            final updatedActivity = DailyHealthDataModel(
              date: today,
              steps: dataType == 'steps' ? value.toInt() : (currentStats?.steps ?? 0),
              calories: dataType == 'calories' ? value.toInt() : (currentStats?.calories ?? 0),
              distance: dataType == 'distance' ? value : (currentStats?.distance ?? 0.0),
              activeMinutes: dataType == 'activeMinutes' ? value.toInt() : (currentStats?.activeMinutes ?? 0),
            );
            
            await healthNotifier.updateDailyActivity(updatedActivity);
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }
}

class _ManualEntryDialog extends StatefulWidget {
  final String dataType;
  final Function(double) onSave;

  const _ManualEntryDialog({
    Key? key,
    required this.dataType,
    required this.onSave,
  }) : super(key: key);

  @override
  _ManualEntryDialogState createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<_ManualEntryDialog> {
  final TextEditingController _controller = TextEditingController();

  String get _title {
    switch (widget.dataType) {
      case 'steps':
        return 'Add Steps';
      case 'calories':
        return 'Add Calories';
      case 'distance':
        return 'Add Distance';
      case 'activeMinutes':
        return 'Add Active Minutes';
      default:
        return 'Add Data';
    }
  }

  String get _hint {
    switch (widget.dataType) {
      case 'steps':
        return 'Enter steps count';
      case 'calories':
        return 'Enter calories burned';
      case 'distance':
        return 'Enter distance (km)';
      case 'activeMinutes':
        return 'Enter active minutes';
      default:
        return 'Enter value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _title,
        style: TextStyleHelper.instance.title20SemiBoldPoppins
            .copyWith(color: appTheme.blue_gray_900),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: _hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: appTheme.green_500),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.gray_600),
          ),
        ),
        CustomButton(
          text: 'Save',
          onPressed: () {
            final value = double.tryParse(_controller.text);
            if (value != null && value >= 0) {
              widget.onSave(value);
            }
          },
          backgroundColor: appTheme.green_500,
          textColor: appTheme.white_A700,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
          borderRadius: 8.h,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
