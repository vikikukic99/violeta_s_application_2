import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../presentation/profile_screen/models/health_dashboard_model.dart';

class HealthService {
  static const String baseUrl = ''; // Use relative URLs for same-origin requests

  // Get current user's health profile
  Future<HealthGoalsModel?> getHealthProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Get health profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HealthGoalsModel.fromJson(data);
      } else if (response.statusCode == 404) {
        // No health profile found, return default goals
        return const HealthGoalsModel();
      }
      return null;
    } catch (e) {
      print('Error fetching health profile: $e');
      return null;
    }
  }

  // Save health profile
  Future<bool> saveHealthProfile(HealthGoalsModel goals) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/health-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'dailyStepsGoal': goals.dailyStepsGoal,
          'dailyCaloriesGoal': goals.dailyCaloriesGoal,
          'weeklyWorkoutsGoal': goals.weeklyWorkoutsGoal,
        }),
      );
      
      print('Save health profile response: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving health profile: $e');
      return false;
    }
  }

  // Get daily activities for a specific date
  Future<DailyHealthDataModel?> getDailyActivity(DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/api/daily-activities?date=$dateStr'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return DailyHealthDataModel.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching daily activity: $e');
      return null;
    }
  }

  // Get daily activities for a date range
  Future<List<DailyHealthDataModel>> getDailyActivitiesRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/api/daily-activities?startDate=$startStr&endDate=$endStr'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data
              .map((item) => DailyHealthDataModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching daily activities range: $e');
      return [];
    }
  }

  // Get recent daily activities
  Future<List<DailyHealthDataModel>> getRecentDailyActivities({int limit = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/daily-activities?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data
              .map((item) => DailyHealthDataModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching recent daily activities: $e');
      return [];
    }
  }

  // Save daily activity
  Future<bool> saveDailyActivity(DailyHealthDataModel activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/daily-activities'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'date': activity.date.toIso8601String(),
          'steps': activity.steps,
          'caloriesBurned': activity.calories,
          'distanceKm': activity.distance,
          'activeMinutes': activity.activeMinutes,
          'heartRateAvg': activity.heartRateAvg,
          'sleepHours': activity.sleepHours,
          'dataSource': 'manual',
        }),
      );
      
      print('Save daily activity response: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving daily activity: $e');
      return false;
    }
  }

  // Get health integrations
  Future<List<ConnectedServiceModel>> getHealthIntegrations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health-integrations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Get health integrations response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data
              .map((item) => ConnectedServiceModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching health integrations: $e');
      return [];
    }
  }

  // Generate today's health stats combining daily activity with goals
  Future<HealthStatsModel> getTodayStats() async {
    try {
      final goals = await getHealthProfile() ?? const HealthGoalsModel();
      final today = await getDailyActivity(DateTime.now());

      return HealthStatsModel(
        steps: today?.steps ?? 0,
        stepsGoal: goals.dailyStepsGoal,
        calories: today?.calories ?? 0,
        caloriesGoal: goals.dailyCaloriesGoal ?? 2000,
        distance: today?.distance ?? 0.0,
        activeMinutes: today?.activeMinutes ?? 0,
        activeMinutesGoal: goals.dailyActiveMinutesGoal ?? 30,
        waterIntake: 0.0, // Could be extended from daily activity
        waterGoal: goals.dailyWaterGoal,
        heartRateAvg: today?.heartRateAvg,
        sleepHours: today?.sleepHours,
        sleepGoal: goals.dailySleepGoal,
      );
    } catch (e) {
      print('Error generating today stats: $e');
      return const HealthStatsModel();
    }
  }

  // Get comprehensive health dashboard data
  Future<HealthDashboardModel> getHealthDashboard() async {
    try {
      final todayStats = await getTodayStats();
      final weeklyData = await getRecentDailyActivities(limit: 7);
      final goals = await getHealthProfile() ?? const HealthGoalsModel();
      final connectedServices = await getHealthIntegrations();

      return HealthDashboardModel(
        todayStats: todayStats,
        weeklyData: weeklyData,
        goals: goals,
        connectedServices: connectedServices,
        isLoading: false,
      );
    } catch (e) {
      print('Error fetching health dashboard: $e');
      return const HealthDashboardModel(
        isLoading: false,
        error: 'Failed to load health data',
      );
    }
  }
}