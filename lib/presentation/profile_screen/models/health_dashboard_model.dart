import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class HealthDashboardModel extends Equatable {
  final HealthStatsModel? todayStats;
  final List<DailyHealthDataModel>? weeklyData;
  final HealthGoalsModel? goals;
  final List<ConnectedServiceModel>? connectedServices;
  final bool isLoading;
  final String? error;

  const HealthDashboardModel({
    this.todayStats,
    this.weeklyData,
    this.goals,
    this.connectedServices,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        todayStats,
        weeklyData,
        goals,
        connectedServices,
        isLoading,
        error,
      ];

  HealthDashboardModel copyWith({
    HealthStatsModel? todayStats,
    List<DailyHealthDataModel>? weeklyData,
    HealthGoalsModel? goals,
    List<ConnectedServiceModel>? connectedServices,
    bool? isLoading,
    String? error,
  }) {
    return HealthDashboardModel(
      todayStats: todayStats ?? this.todayStats,
      weeklyData: weeklyData ?? this.weeklyData,
      goals: goals ?? this.goals,
      connectedServices: connectedServices ?? this.connectedServices,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HealthStatsModel extends Equatable {
  final int steps;
  final int stepsGoal;
  final int calories;
  final int caloriesGoal;
  final double distance; // in km
  final int activeMinutes;
  final int activeMinutesGoal;
  final double? waterIntake; // in liters
  final double? waterGoal;
  final int? heartRateAvg;
  final double? sleepHours;
  final double? sleepGoal;

  const HealthStatsModel({
    this.steps = 0,
    this.stepsGoal = 10000,
    this.calories = 0,
    this.caloriesGoal = 2000,
    this.distance = 0.0,
    this.activeMinutes = 0,
    this.activeMinutesGoal = 30,
    this.waterIntake,
    this.waterGoal = 2.0,
    this.heartRateAvg,
    this.sleepHours,
    this.sleepGoal = 8.0,
  });

  double get stepsProgress => stepsGoal > 0 ? (steps / stepsGoal).clamp(0.0, 1.0) : 0.0;
  double get caloriesProgress => caloriesGoal > 0 ? (calories / caloriesGoal).clamp(0.0, 1.0) : 0.0;
  double get activeMinutesProgress => activeMinutesGoal > 0 ? (activeMinutes / activeMinutesGoal).clamp(0.0, 1.0) : 0.0;
  double get waterProgress => waterGoal != null && waterGoal! > 0 ? ((waterIntake ?? 0) / waterGoal!).clamp(0.0, 1.0) : 0.0;
  double get sleepProgress => sleepGoal != null && sleepGoal! > 0 ? ((sleepHours ?? 0) / sleepGoal!).clamp(0.0, 1.0) : 0.0;

  @override
  List<Object?> get props => [
        steps,
        stepsGoal,
        calories,
        caloriesGoal,
        distance,
        activeMinutes,
        activeMinutesGoal,
        waterIntake,
        waterGoal,
        heartRateAvg,
        sleepHours,
        sleepGoal,
      ];

  HealthStatsModel copyWith({
    int? steps,
    int? stepsGoal,
    int? calories,
    int? caloriesGoal,
    double? distance,
    int? activeMinutes,
    int? activeMinutesGoal,
    double? waterIntake,
    double? waterGoal,
    int? heartRateAvg,
    double? sleepHours,
    double? sleepGoal,
  }) {
    return HealthStatsModel(
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      calories: calories ?? this.calories,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      distance: distance ?? this.distance,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      activeMinutesGoal: activeMinutesGoal ?? this.activeMinutesGoal,
      waterIntake: waterIntake ?? this.waterIntake,
      waterGoal: waterGoal ?? this.waterGoal,
      heartRateAvg: heartRateAvg ?? this.heartRateAvg,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepGoal: sleepGoal ?? this.sleepGoal,
    );
  }
}

class DailyHealthDataModel extends Equatable {
  final DateTime date;
  final int steps;
  final int calories;
  final double distance;
  final int activeMinutes;
  final int? heartRateAvg;
  final double? sleepHours;

  const DailyHealthDataModel({
    required this.date,
    this.steps = 0,
    this.calories = 0,
    this.distance = 0.0,
    this.activeMinutes = 0,
    this.heartRateAvg,
    this.sleepHours,
  });

  @override
  List<Object?> get props => [
        date,
        steps,
        calories,
        distance,
        activeMinutes,
        heartRateAvg,
        sleepHours,
      ];

  factory DailyHealthDataModel.fromJson(Map<String, dynamic> json) {
    return DailyHealthDataModel(
      date: DateTime.parse(json['date']),
      steps: json['steps'] ?? 0,
      calories: json['caloriesBurned'] ?? 0,
      distance: double.tryParse(json['distanceKm']?.toString() ?? '0') ?? 0.0,
      activeMinutes: json['activeMinutes'] ?? 0,
      heartRateAvg: json['heartRateAvg'],
      sleepHours: double.tryParse(json['sleepHours']?.toString() ?? '0'),
    );
  }
}

class HealthGoalsModel extends Equatable {
  final int dailyStepsGoal;
  final int? dailyCaloriesGoal;
  final int weeklyWorkoutsGoal;
  final double? dailyWaterGoal;
  final int? dailyActiveMinutesGoal;
  final double? dailySleepGoal;

  const HealthGoalsModel({
    this.dailyStepsGoal = 10000,
    this.dailyCaloriesGoal,
    this.weeklyWorkoutsGoal = 3,
    this.dailyWaterGoal = 2.0,
    this.dailyActiveMinutesGoal = 30,
    this.dailySleepGoal = 8.0,
  });

  @override
  List<Object?> get props => [
        dailyStepsGoal,
        dailyCaloriesGoal,
        weeklyWorkoutsGoal,
        dailyWaterGoal,
        dailyActiveMinutesGoal,
        dailySleepGoal,
      ];

  factory HealthGoalsModel.fromJson(Map<String, dynamic> json) {
    return HealthGoalsModel(
      dailyStepsGoal: json['dailyStepsGoal'] ?? 10000,
      dailyCaloriesGoal: json['dailyCaloriesGoal'],
      weeklyWorkoutsGoal: json['weeklyWorkoutsGoal'] ?? 3,
      dailyWaterGoal: 2.0, // Default as it's not in backend schema
      dailyActiveMinutesGoal: 30, // Default as it's not in backend schema
      dailySleepGoal: 8.0, // Default as it's not in backend schema
    );
  }

  HealthGoalsModel copyWith({
    int? dailyStepsGoal,
    int? dailyCaloriesGoal,
    int? weeklyWorkoutsGoal,
    double? dailyWaterGoal,
    int? dailyActiveMinutesGoal,
    double? dailySleepGoal,
  }) {
    return HealthGoalsModel(
      dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
      weeklyWorkoutsGoal: weeklyWorkoutsGoal ?? this.weeklyWorkoutsGoal,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      dailyActiveMinutesGoal: dailyActiveMinutesGoal ?? this.dailyActiveMinutesGoal,
      dailySleepGoal: dailySleepGoal ?? this.dailySleepGoal,
    );
  }
}

class ConnectedServiceModel extends Equatable {
  final String serviceName;
  final String displayName;
  final bool isActive;
  final bool isConnected;
  final DateTime? lastSyncAt;
  final String iconPath;
  final Color backgroundColor;

  const ConnectedServiceModel({
    required this.serviceName,
    required this.displayName,
    this.isActive = false,
    this.isConnected = false,
    this.lastSyncAt,
    required this.iconPath,
    required this.backgroundColor,
  });

  @override
  List<Object?> get props => [
        serviceName,
        displayName,
        isActive,
        isConnected,
        lastSyncAt,
        iconPath,
        backgroundColor,
      ];

  factory ConnectedServiceModel.fromJson(Map<String, dynamic> json) {
    final serviceName = json['serviceName'] ?? '';
    return ConnectedServiceModel(
      serviceName: serviceName,
      displayName: _getDisplayName(serviceName),
      isActive: json['isActive'] ?? false,
      isConnected: true,
      lastSyncAt: json['lastSyncAt'] != null ? DateTime.parse(json['lastSyncAt']) : null,
      iconPath: _getIconPath(serviceName),
      backgroundColor: _getBackgroundColor(serviceName),
    );
  }

  static String _getDisplayName(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'google_fit':
        return 'Google Fit';
      case 'apple_health':
        return 'Apple Health';
      case 'fitbit':
        return 'Fitbit';
      case 'strava':
        return 'Strava';
      case 'garmin':
        return 'Garmin';
      case 'samsung_health':
        return 'Samsung Health';
      default:
        return serviceName;
    }
  }

  static String _getIconPath(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'google_fit':
        return ImageConstant.imgFrameGreen500;
      case 'apple_health':
        return ImageConstant.imgIWhiteA700;
      case 'fitbit':
        return ImageConstant.imgFrameTeal400;
      case 'strava':
        return ImageConstant.imgVectorAmber500;
      case 'garmin':
        return ImageConstant.imgFrameBlueGray900;
      case 'samsung_health':
        return ImageConstant.imgI;
      default:
        return ImageConstant.imgI;
    }
  }

  static Color _getBackgroundColor(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'google_fit':
        return appTheme.green_50;
      case 'apple_health':
        return appTheme.gray_50;
      case 'fitbit':
        return appTheme.teal_50;
      case 'strava':
        return appTheme.yellow_50;
      case 'garmin':
        return appTheme.blue_gray_50;
      case 'samsung_health':
        return appTheme.blue_50;
      default:
        return appTheme.gray_50;
    }
  }

  ConnectedServiceModel copyWith({
    String? serviceName,
    String? displayName,
    bool? isActive,
    bool? isConnected,
    DateTime? lastSyncAt,
    String? iconPath,
    Color? backgroundColor,
  }) {
    return ConnectedServiceModel(
      serviceName: serviceName ?? this.serviceName,
      displayName: displayName ?? this.displayName,
      isActive: isActive ?? this.isActive,
      isConnected: isConnected ?? this.isConnected,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      iconPath: iconPath ?? this.iconPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}