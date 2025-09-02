part of 'activity_selection_notifier.dart';

class ActivitySelectionState extends Equatable {
  ActivitySelectionState({
    this.activitySelectionModel,
    this.activitiesList,
    this.selectedTime,
    this.isFormSubmitted,
    this.selectedActivitiesCount,
    this.timeController,
    this.descriptionController,
    this.locationController,
    this.citySearchResults,
    this.isSearchingLocation,
    this.selectedCity,
    this.currentPosition,
    this.locationError,
    this.isAIEnhancing,
    this.aiSuggestions,
  }) {
    activitySelectionModel = activitySelectionModel ?? ActivitySelectionModel();
    activitiesList = activitiesList ?? [];
    selectedTime = selectedTime;
    isFormSubmitted = isFormSubmitted ?? false;
    selectedActivitiesCount = selectedActivitiesCount ?? 0;
    citySearchResults = citySearchResults ?? [];
    isSearchingLocation = isSearchingLocation ?? false;
    selectedCity = selectedCity;
    currentPosition = currentPosition;
    locationError = locationError;
    isAIEnhancing = isAIEnhancing ?? false;
    aiSuggestions = aiSuggestions ?? [];
  }

  ActivitySelectionModel? activitySelectionModel;
  List<ActivityModel>? activitiesList;
  TimeOfDay? selectedTime;
  bool? isFormSubmitted;
  int? selectedActivitiesCount;
  TextEditingController? timeController;
  TextEditingController? descriptionController;
  TextEditingController? locationController;
  List<String>? citySearchResults;
  bool? isSearchingLocation;
  String? selectedCity;
  Position? currentPosition;
  String? locationError;
  bool? isAIEnhancing;
  List<String>? aiSuggestions;

  @override
  List<Object?> get props => [
        activitySelectionModel,
        activitiesList,
        selectedTime,
        isFormSubmitted,
        selectedActivitiesCount,
        timeController,
        descriptionController,
        locationController,
        citySearchResults,
        isSearchingLocation,
        selectedCity,
        currentPosition,
        locationError,
        isAIEnhancing,
        aiSuggestions,
      ];

  ActivitySelectionState copyWith({
    ActivitySelectionModel? activitySelectionModel,
    List<ActivityModel>? activitiesList,
    TimeOfDay? selectedTime,
    bool? isFormSubmitted,
    int? selectedActivitiesCount,
    TextEditingController? timeController,
    TextEditingController? descriptionController,
    TextEditingController? locationController,
    List<String>? citySearchResults,
    bool? isSearchingLocation,
    String? selectedCity,
    Position? currentPosition,
    String? locationError,
    bool? isAIEnhancing,
    List<String>? aiSuggestions,
  }) {
    return ActivitySelectionState(
      activitySelectionModel:
          activitySelectionModel ?? this.activitySelectionModel,
      activitiesList: activitiesList ?? this.activitiesList,
      selectedTime: selectedTime ?? this.selectedTime,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      selectedActivitiesCount:
          selectedActivitiesCount ?? this.selectedActivitiesCount,
      timeController: timeController ?? this.timeController,
      descriptionController:
          descriptionController ?? this.descriptionController,
      locationController: locationController ?? this.locationController,
      citySearchResults: citySearchResults ?? this.citySearchResults,
      isSearchingLocation: isSearchingLocation ?? this.isSearchingLocation,
      selectedCity: selectedCity ?? this.selectedCity,
      currentPosition: currentPosition ?? this.currentPosition,
      locationError: locationError,
      isAIEnhancing: isAIEnhancing ?? this.isAIEnhancing,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
    );
  }
}
