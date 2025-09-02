import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/app_export.dart';
import '../models/activity_model.dart';
import '../models/activity_selection_model.dart';

part 'activity_selection_state.dart';

final activitySelectionNotifier = StateNotifierProvider.autoDispose<
    ActivitySelectionNotifier, ActivitySelectionState>(
  (ref) => ActivitySelectionNotifier(
    ActivitySelectionState(
      activitySelectionModel: ActivitySelectionModel(),
    ),
  ),
);

class ActivitySelectionNotifier extends StateNotifier<ActivitySelectionState> {
  ActivitySelectionNotifier(ActivitySelectionState state) : super(state) {
    initialize();
  }

  void initialize() {
    final activities = [
      ActivityModel(
        id: '1',
        title: 'Walking',
        iconPath: ImageConstant.imgIGreen500,
        isSelected: true,
      ),
      ActivityModel(
        id: '2',
        title: 'Dog Walking',
        iconPath: ImageConstant.imgIGray600,
        isSelected: false,
      ),
      ActivityModel(
        id: '3',
        title: 'Cycling',
        iconPath: ImageConstant.imgIGray60048x48,
        isSelected: false,
      ),
      ActivityModel(
        id: '4',
        title: 'Running',
        iconPath: ImageConstant.imgIGreen50048x48,
        isSelected: true,
      ),
    ];

    state = state.copyWith(
      activitiesList: activities,
      timeController: TextEditingController(text: '10:00'),
      descriptionController: TextEditingController(),
      locationController: TextEditingController(),
      citySearchResults: [],
      isSearchingLocation: false,
    );
  }

  void toggleActivitySelection(ActivityModel activity) {
    final updatedActivities = state.activitiesList?.map((item) {
      if (item.id == activity.id) {
        return item.copyWith(isSelected: !(item.isSelected ?? false));
      }
      return item;
    }).toList();

    state = state.copyWith(activitiesList: updatedActivities);
  }

  void setSelectedTime(TimeOfDay time) {
    final timeString =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    state.timeController?.text = timeString;
    state = state.copyWith(selectedTime: time);
  }

  void setStartNow() {
    final now = TimeOfDay.now();
    setSelectedTime(now);
  }

  // Location functionality
  Future<void> searchCitiesByName(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(citySearchResults: []);
      return;
    }

    try {
      state = state.copyWith(isSearchingLocation: true);
      final locations = await locationFromAddress(query);

      final List<String> cityResults = [];
      for (final location in locations.take(5)) {
        try {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            final cityName =
                '${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}'
                    .replaceAll(RegExp(r'^,|,$'), '')
                    .replaceAll(', ,', ', ');
            if (cityName.isNotEmpty && !cityResults.contains(cityName)) {
              cityResults.add(cityName);
            }
          }
        } catch (e) {
          // Skip this location if reverse geocoding fails
          continue;
        }
      }

      state = state.copyWith(
        citySearchResults: cityResults,
        isSearchingLocation: false,
      );
    } catch (e) {
      state = state.copyWith(
        citySearchResults: [],
        isSearchingLocation: false,
        locationError: 'Failed to search cities: ${e.toString()}',
      );
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      state = state.copyWith(isSearchingLocation: true, locationError: null);

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isSearchingLocation: false,
          locationError: 'Location services are disabled.',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isSearchingLocation: false,
            locationError: 'Location permissions are denied',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isSearchingLocation: false,
          locationError:
              'Location permissions are permanently denied, please enable them in settings.',
        );
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      // Get city name from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final cityName =
            '${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}'
                .replaceAll(RegExp(r'^,|,$'), '')
                .replaceAll(', ,', ', ');

        state.locationController?.text = cityName;
        state = state.copyWith(
          selectedCity: cityName,
          currentPosition: position,
          isSearchingLocation: false,
        );
      } else {
        state = state.copyWith(
          isSearchingLocation: false,
          locationError: 'Could not determine city from current location',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSearchingLocation: false,
        locationError: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  void selectCity(String cityName) {
    state.locationController?.text = cityName;
    state = state.copyWith(
      selectedCity: cityName,
      citySearchResults: [],
    );
  }

  void clearLocationError() {
    state = state.copyWith(locationError: null);
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please tell us more about yourself';
    }
    if (value.trim().length < 10) {
      return 'Please provide at least 10 characters';
    }
    return null;
  }

  void submitForm() {
    final selectedActivities = state.activitiesList
        ?.where((activity) => activity.isSelected ?? false)
        .toList();

    state = state.copyWith(
      isFormSubmitted: true,
      selectedActivitiesCount: selectedActivities?.length ?? 0,
    );

    // Clear form after successful submission
    state.descriptionController?.clear();
    state.timeController?.text = '10:00';
  }

  @override
  void dispose() {
    state.timeController?.dispose();
    state.descriptionController?.dispose();
    state.locationController?.dispose();
    super.dispose();
  }
}
