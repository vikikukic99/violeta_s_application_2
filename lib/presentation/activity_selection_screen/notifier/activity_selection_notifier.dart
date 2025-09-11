import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../../core/app_export.dart';

class ActivityItem {
  final String id;
  final String title;
  final IconData icon;
  final bool selected;

  ActivityItem({
    required this.id,
    required this.title,
    required this.icon,
    this.selected = false,
  });

  ActivityItem copyWith({bool? selected}) =>
      ActivityItem(id: id, title: title, icon: icon, selected: selected ?? this.selected);
}

class ActivitySelectionState {
  final List<ActivityItem>? activitiesList;
  final TextEditingController? locationController;
  final TextEditingController? timeController;
  final TextEditingController? descriptionController;
  final bool? isSearchingLocation;
  final String? locationError;
  final List<String>? citySearchResults;

  ActivitySelectionState({
    this.activitiesList,
    this.locationController,
    this.timeController,
    this.descriptionController,
    this.isSearchingLocation,
    this.locationError,
    this.citySearchResults,
  });

  ActivitySelectionState copyWith({
    List<ActivityItem>? activitiesList,
    TextEditingController? locationController,
    TextEditingController? timeController,
    TextEditingController? descriptionController,
    bool? isSearchingLocation,
    String? locationError,
    List<String>? citySearchResults,
  }) {
    return ActivitySelectionState(
      activitiesList: activitiesList ?? this.activitiesList,
      locationController: locationController ?? this.locationController,
      timeController: timeController ?? this.timeController,
      descriptionController: descriptionController ?? this.descriptionController,
      isSearchingLocation: isSearchingLocation ?? this.isSearchingLocation,
      locationError: locationError,
      citySearchResults: citySearchResults ?? this.citySearchResults,
    );
  }
}

class ActivitySelectionNotifier extends StateNotifier<ActivitySelectionState> {
  ActivitySelectionNotifier()
      : super(
          ActivitySelectionState(
            activitiesList: [
              ActivityItem(id: 'walking', title: 'Walking', icon: Icons.emoji_people),
              ActivityItem(id: 'dog_walking', title: 'Dog Walking', icon: Icons.pets),
              ActivityItem(id: 'cycling', title: 'Cycling', icon: Icons.pedal_bike),
              ActivityItem(id: 'running', title: 'Running', icon: Icons.directions_run),
            ],
            locationController: TextEditingController(),
            timeController: TextEditingController(text: '10:00'),
            descriptionController: TextEditingController(),
            isSearchingLocation: false,
            locationError: null,
            citySearchResults: const [],
          ),
        ) {
    // Automatically try to get user's location when the notifier is created
    _autoGetLocation();
  }

  // Private method to automatically get location on initialization
  void _autoGetLocation() async {
    // Only auto-get location if the field is empty
    if (state.locationController?.text.isEmpty ?? true) {
      try {
        // Check if location services are enabled first
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return; // Exit silently if location services are disabled
        }

        // Check current permission status
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return; // Exit silently if permission is denied - user can manually tap button
        }

        // If we have permission, get location automatically
        await getCurrentLocation();
      } catch (e) {
        // Fail silently - user can manually tap the location button if needed
      }
    }
  }

  /* ------------------------ Activities ------------------------ */

  void toggleActivitySelection(ActivityItem item) {
    final list = [...(state.activitiesList ?? [])];
    final idx = list.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      list[idx] = list[idx].copyWith(selected: !list[idx].selected);
      state = state.copyWith(activitiesList: list);
    }
  }

  /* ------------------------ Location ------------------------ */

  Future<void> getCurrentLocation() async {
    try {
      state = state.copyWith(
        isSearchingLocation: true,
        locationError: null,
        citySearchResults: const [],
      );

      final permission = await Geolocator.checkPermission();
      LocationPermission perm = permission;
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        state = state.copyWith(
          isSearchingLocation: false,
          locationError: 'Failed to get current location: User has not allowed access to system location.',
        );
        return;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Use reverse geocoding to get actual city name
      try {
        final placemarks = await placemarkFromCoordinates(
          pos.latitude, 
          pos.longitude
        );
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final cityName = placemark.locality ?? 
                          placemark.subAdministrativeArea ?? 
                          placemark.administrativeArea ?? 
                          'Unknown Location';
          
          final countryCode = placemark.isoCountryCode ?? '';
          final locationText = countryCode.isNotEmpty 
              ? '$cityName, $countryCode' 
              : cityName;
          
          state.locationController?.text = locationText;
        } else {
          // Fallback to coordinates if no placemark found
          state.locationController?.text =
              '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
        }
      } catch (e) {
        // Fallback to coordinates if geocoding fails
        state.locationController?.text =
            '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
      }

      state = state.copyWith(isSearchingLocation: false, locationError: null);
    } catch (e) {
      state = state.copyWith(
        isSearchingLocation: false,
        locationError: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  void clearLocationError() {
    state = state.copyWith(locationError: null);
  }

  void selectCity(String city) {
    state.locationController?.text = city;
    state = state.copyWith(citySearchResults: const []);
  }

  /* ------------------------ Time ------------------------ */

  void setSelectedTime(TimeOfDay time) {
    state.timeController?.text = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void setStartNow() {
    final now = TimeOfDay.now();
    state.timeController?.text = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  /* ------------------------ Form Validation ------------------------ */

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please tell us a bit about yourself or tap the AI Assistant for suggestions';
    }
    return null;
  }

  /* ------------------------ Form Submission ------------------------ */

  void submitForm() {
    // Here you would typically send the data to your backend
    // For now, just clear the form or navigate
    print('Submitting form with:');
    print('Activities: ${state.activitiesList?.where((a) => a.selected).map((a) => a.title).join(', ')}');
    print('Location: ${state.locationController?.text}');
    print('Time: ${state.timeController?.text}');
    print('Description: ${state.descriptionController?.text}');
  }

  /* ------------------------ AI Suggestions ------------------------ */

  Future<List<String>> getAISuggestions() async {
    try {
      // Get context from selected activities and location
      final selectedActivities = state.activitiesList
          ?.where((activity) => activity.selected)
          .map((activity) => activity.title)
          .toList() ?? [];
      
      final location = state.locationController?.text?.isNotEmpty == true
          ? state.locationController!.text
          : '';
      
      final preferredTime = state.timeController?.text?.isNotEmpty == true
          ? state.timeController!.text
          : '';

      // Call the OpenAI backend API
      return await _callOpenAIBackend(selectedActivities, location, preferredTime);
    } catch (e) {
      // Fallback to contextual suggestions if backend fails
      final selectedActivitiesText = state.activitiesList
          ?.where((activity) => activity.selected)
          .map((activity) => activity.title)
          .join(', ') ?? 'fitness activities';
      
      final location = state.locationController?.text ?? '';
      final preferredTime = state.timeController?.text ?? '';
      
      return _generateContextualSuggestions(selectedActivitiesText, location, preferredTime);
    }
  }

  Future<List<String>> _callOpenAIBackend(List<String> activities, String location, String preferredTime) async {
    try {
      final dio = Dio();
      
      // Use relative path since Flutter web and backend are served from same origin
      // This works in production and avoids hardcoded domains
      final response = await dio.post(
        '/api/generate-suggestions',
        data: {
          'activities': activities.map((title) => {'title': title}).toList(),
          'location': location,
          'preferredTime': preferredTime,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('suggestions')) {
          final suggestions = List<String>.from(data['suggestions'] ?? []);
          if (suggestions.isNotEmpty) {
            return suggestions;
          }
        }
      }
      
      // If we get here, the response wasn't in the expected format
      throw Exception('Invalid response format from OpenAI backend');
      
    } catch (e) {
      print('Failed to get AI suggestions from backend: $e');
      // Re-throw to trigger fallback in getAISuggestions
      throw e;
    }
  }

  List<String> _generateContextualSuggestions(String activities, String location, String time) {
    final locationContext = location.isNotEmpty ? ' in $location' : '';
    final timeContext = time.isNotEmpty ? ' who prefers $time activities' : '';
    
    if (activities.contains('Dog Walking')) {
      return [
        'I\'m a dog lover who enjoys combining pet care with fitness$locationContext.',
        'Looking for fellow dog owners for safe, fun walking adventures$timeContext.',
        'My furry companion and I love exploring dog-friendly trails and parks.',
        'Seeking walking buddies who understand the joy of exercising with our four-legged friends.'
      ];
    } else if (activities.contains('Running')) {
      return [
        'Passionate runner seeking training partners for motivation and safety$locationContext.',
        'I believe running is better with company - let\'s push each other to reach our goals$timeContext.',
        'Love the endorphin rush and would enjoy sharing that experience with like-minded runners.',
        'Training for personal bests and would love supportive running companions to join me.'
      ];
    } else if (activities.contains('Cycling')) {
      return [
        'Cycling enthusiast looking for adventure buddies to explore scenic routes$locationContext.',
        'I enjoy both casual rides and challenging trails - seeking versatile cycling partners$timeContext.',
        'Believe cycling is the perfect blend of fitness and exploration.',
        'Looking for safety-conscious cycling companions who love discovering new paths.'
      ];
    } else {
      return [
        'I love staying active through walking and discovering new places$locationContext.',
        'Seeking friendly fitness companions who enjoy meaningful conversations during walks$timeContext.',
        'Believe the best workouts happen when you\'re having fun with great company.',
        'Looking for accountability partners who share my passion for healthy, active living.'
      ];
    }
  }

  @override
  void dispose() {
    state.locationController?.dispose();
    state.timeController?.dispose();
    state.descriptionController?.dispose();
    super.dispose();
  }
}

// Provider for the activity selection notifier
final activitySelectionNotifierProvider = StateNotifierProvider<ActivitySelectionNotifier, ActivitySelectionState>((ref) {
  return ActivitySelectionNotifier();
});