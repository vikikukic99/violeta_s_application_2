import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
        );

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

      // NOTE: Reverse geocoding left as an exercise depending on your chosen service.
      // For now, just display lat/lng for verification.
      state.locationController?.text =
          'Lat: ${pos.latitude.toStringAsFixed(4)}, Lng: ${pos.longitude.toStringAsFixed(4)}';

      state = state.copyWith(isSearchingLocation: false, locationError: null);
    } catch (e) {
      state = state.copyWith(
        isSearchingLocation: false,
        locationError: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  void clearLocationError() {
    state = state.copyWith(locationError: