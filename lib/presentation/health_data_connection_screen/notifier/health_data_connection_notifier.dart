import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_data_connection_model.dart';
import '../../../core/app_export.dart';

part 'health_data_connection_state.dart';

final healthDataConnectionNotifier = StateNotifierProvider.autoDispose<
    HealthDataConnectionNotifier, HealthDataConnectionState>(
  (ref) => HealthDataConnectionNotifier(
    HealthDataConnectionState(
      healthDataConnectionModel: HealthDataConnectionModel(),
    ),
  ),
);

class HealthDataConnectionNotifier
    extends StateNotifier<HealthDataConnectionState> {
  HealthDataConnectionNotifier(HealthDataConnectionState state) : super(state) {
    initialize();
  }

  // Get the backend base URL based on environment
  String get baseUrl {
    // Use relative URLs for same-origin requests to work in all environments
    return '';
  }

  void initialize() async {
    state = state.copyWith(
      isLoading: true,
      isConnected: false,
    );
    
    try {
      await _checkExistingIntegrations();
    } catch (e) {
      print('Error checking integrations: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to check existing health integrations',
      );
    }
  }

  Future<void> _checkExistingIntegrations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health-integrations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Health integrations response status: ${response.statusCode}');
      print('Health integrations response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> integrations = json.decode(response.body);
        final hasGoogleFit = integrations.any((integration) => 
          integration['serviceName'] == 'google_fit' && integration['isActive'] == true);
        
        state = state.copyWith(
          isLoading: false,
          isConnected: hasGoogleFit,
          selectedApp: hasGoogleFit ? 'Google Fit' : null,
          existingIntegrations: integrations.cast<Map<String, dynamic>>(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isConnected: false,
        );
      }
    } catch (e) {
      print('Error checking integrations: $e');
      state = state.copyWith(
        isLoading: false,
        isConnected: false,
      );
    }
  }

  Future<void> connectGoogleFit() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // Check Google Fit status first
      final statusResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/google-fit/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Google Fit status response: ${statusResponse.statusCode}');
      print('Google Fit status body: ${statusResponse.body}');

      if (statusResponse.statusCode == 200) {
        final statusData = json.decode(statusResponse.body);
        if (statusData['connected'] == true) {
          state = state.copyWith(
            isLoading: false,
            isConnected: true,
            isSuccess: true,
            selectedApp: 'Google Fit',
          );
          return;
        }
      } else if (statusResponse.statusCode == 401) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Please log in first to connect Google Fit.',
        );
        return;
      } else if (statusResponse.statusCode == 503) {
        final errorData = json.decode(statusResponse.body);
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: errorData['message'] ?? 'Google Fit integration is not configured.',
        );
        return;
      }

      // Check if user is authenticated before attempting connection
      final authResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Auth status response: ${authResponse.statusCode}');
      print('Auth status body: ${authResponse.body}');
      
      if (authResponse.statusCode != 200) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Authentication required. Please log in first.',
        );
        return;
      }
      
      final authData = json.decode(authResponse.body);
      if (!authData['isAuthenticated']) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Please log in first to connect Google Fit.',
        );
        return;
      }
      
      // User is authenticated, redirect to Google Fit OAuth
      final connectUrl = '$baseUrl/api/auth/google-fit/connect';
      
      // In a web environment, we would redirect the window
      // For now, show a message to the user
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Please open the Google Fit connection URL manually: $connectUrl',
      );
      
    } catch (e) {
      print('Error connecting to Google Fit: $e');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Failed to connect to Google Fit. Please check your internet connection and try again.',
      );
    }
  }

  Future<void> saveManualHealthData({
    required int dailyStepsGoal,
    required int weeklyWorkoutsGoal,
    int? dailyCaloriesGoal,
    double? weight,
    int? age,
    double? height,
    String? gender,
    String? activityLevel,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // Save health profile
      final profileData = {
        'dailyStepsGoal': dailyStepsGoal,
        'weeklyWorkoutsGoal': weeklyWorkoutsGoal,
        if (dailyCaloriesGoal != null) 'dailyCaloriesGoal': dailyCaloriesGoal,
        if (weight != null) 'weight': weight,
        if (age != null) 'age': age,
        if (height != null) 'height': height,
        if (gender != null) 'gender': gender,
        if (activityLevel != null) 'activityLevel': activityLevel,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/health-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(profileData),
      );
      
      print('Save health profile response: ${response.statusCode}');
      print('Save health profile body: ${response.body}');

      if (response.statusCode == 200) {
        // Save today's activity data if weight is provided
        if (weight != null) {
          await _saveTodayActivity(weight: weight);
        }
        
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          isManualDataSaved: true,
        );
      } else if (response.statusCode == 401) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Authentication required. Please log in first.',
        );
      } else {
        try {
          final errorData = json.decode(response.body);
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: errorData['message'] ?? 'Failed to save health data',
          );
        } catch (parseError) {
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Failed to save health data. Server error: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Error saving manual health data: $e');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Failed to save health data. Please check your connection.',
      );
    }
  }

  Future<void> _saveTodayActivity({double? weight}) async {
    try {
      final today = DateTime.now();
      final activityData = {
        'date': today.toIso8601String(),
        'steps': 0,
        'caloriesBurned': 0,
        'distanceKm': 0,
        'activeMinutes': 0,
        if (weight != null) 'weight': weight,
        'dataSource': 'manual',
        'notes': 'Initial health data setup',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/daily-activities'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(activityData),
      );
      
      print('Save today activity response: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Save today activity error: ${response.body}');
      }
    } catch (e) {
      print('Error saving today activity: $e');
    }
  }

  void selectHealthApp(String appName) {
    state = state.copyWith(
      selectedApp: appName,
    );
    
    if (appName == 'Google Fit') {
      connectGoogleFit();
    }
  }

  void skipConnection() {
    state = state.copyWith(
      isSkipped: true,
    );
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
    );
  }

  void resetState() {
    state = state.copyWith(
      isLoading: false,
      isConnected: false,
      isSuccess: false,
      isSkipped: false,
      isManualDataSaved: false,
      selectedApp: null,
      errorMessage: null,
      existingIntegrations: [],
    );
  }
}
