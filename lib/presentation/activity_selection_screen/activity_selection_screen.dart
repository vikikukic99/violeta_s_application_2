import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_search_view.dart';
import './widgets/activity_card_widget.dart';
import './widgets/ai_enhanced_text_field.dart';
import 'notifier/activity_selection_notifier.dart';

class ActivitySelectionScreen extends ConsumerStatefulWidget {
  const ActivitySelectionScreen({Key? key}) : super(key: key);

  @override
  ActivitySelectionScreenState createState() => ActivitySelectionScreenState();
}

class ActivitySelectionScreenState
    extends ConsumerState<ActivitySelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Local fallback suggestions (used by the AI Assistant popup).
  // If you later expose suggestions from your notifier, you can replace this.
  static const List<String> _aiSuggestions = [
    'I love exploring new walking routes and discovering hidden gems in the city.',
    'Looking for motivated fitness companions who enjoy morning walks and healthy conversations.',
    'Passionate about wellness and building meaningful connections through shared activities.',
    'I’m training for a 5K and would love accountability buddies for weekend runs.',
  ];

  @override
  void initState() {
    super.initState();
    // Check for registration data after authentication
    _handleRegistrationData();
  }

  Future<void> _handleRegistrationData() async {
    try {
      final registrationDataJson = html.window.sessionStorage['registration_data'];
      if (registrationDataJson != null) {
        final registrationData = jsonDecode(registrationDataJson);
        
        // Send registration data to backend
        await _updateUserProfile(registrationData);
        
        // Clear the registration data from storage
        html.window.sessionStorage.remove('registration_data');
      }
    } catch (e) {
      print('Error handling registration data: $e');
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await html.HttpRequest.request(
        '/api/update-profile',
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
        },
        sendData: jsonEncode({
          'fullName': userData['fullName'],
          'nickname': userData['nickname'],
        }),
        withCredentials: true,
      );

      if (response.status == 200) {
        print('User profile updated successfully');
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('Failed to update user profile: ${response.statusText}');
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 38.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What activities interest you today?',
                  style: TextStyleHelper.instance.headline24BoldInter,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Select the activities you enjoy or want to try. '
                  'This helps us match you with like-minded walking buddies.',
                  style: TextStyleHelper.instance.body14RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),
                SizedBox(height: 24.h),

                /// Activities grid (Walking, Dog Walking, Cycling, Running…)
                _buildActivitiesGrid(),

                SizedBox(height: 24.h),
                Text(
                  'Location',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 8.h),

                /// Location input with “use my location” button + error + results
                _buildLocationField(),

                SizedBox(height: 24.h),
                Text(
                  'Start time',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 12.h),

                /// Time field + “Start now”
                _buildTimeSelectionRow(),

                SizedBox(height: 24.h),
                Text(
                  'Tell us more about you.',
                  style: TextStyleHelper.instance.headline24BoldInter,
                ),
                SizedBox(height: 16.h),

                /// Description with AI-enhanced text field
                _buildAIEnhancedDescriptionField(),

                /// Small AI Assistant chip that opens a popup of suggestions
                SizedBox(height: 12.h),
                _buildAiAssistantChip(),

                SizedBox(height: 40.h),

                /// Continue — uses frameless Material icon (no white box)
                CustomButton(
                  text: 'Continue',
                  backgroundColor: appTheme.green_500,
                  textColor: appTheme.white_A700,
                  rightIconWidget: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18.h,
                    color: appTheme.white_A700,
                  ),
                  elevation: 6,
                  width: double.infinity,
                  onPressed: () => onTapContinue(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesGrid() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(activitySelectionNotifier);
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.h,
          childAspectRatio: 1.3,
          children: List.generate(
            state.activitiesList?.length ?? 0,
            (index) {
              final activity = state.activitiesList![index];
              return ActivityCardWidget(
                activity: activity,
                onTap: () {
                  ref
                      .read(activitySelectionNotifier.notifier)
                      .toggleActivitySelection(activity);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLocationField() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(activitySelectionNotifier);
        final notifier = ref.read(activitySelectionNotifier.notifier);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomEditText(
                    controller: state.locationController,
                    hintText: 'Find your city',
                    borderColor: appTheme.blue_gray_100,
                    backgroundColor: appTheme.white_A700,
                  ),
                ),
                SizedBox(width: 12.h),
                GestureDetector(
                  onTap: () => notifier.getCurrentLocation(),
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: appTheme.green_500,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: state.isSearchingLocation == true
                        ? Center(
                            child: SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: CircularProgressIndicator(
                                color: appTheme.white_A700,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.my_location,
                            color: appTheme.white_A700,
                            size: 20.h,
                          ),
                  ),
                ),
              ],
            ),

            /// Error bubble
            if (state.locationError != null) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: appTheme.colorFFEF44.withAlpha(26),
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(color: appTheme.colorFFEF44),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: appTheme.colorFFEF44, size: 16.h),
                    SizedBox(width: 8.h),
                    Expanded(
                      child: Text(
                        state.locationError!,
                        style: TextStyleHelper.instance.body12RegularInter
                            .copyWith(color: appTheme.colorFFEF44),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => notifier.clearLocationError(),
                      child: Icon(Icons.close,
                          color: appTheme.colorFFEF44, size: 16.h),
                    ),
                  ],
                ),
              ),
            ],

            /// Autocomplete list
            if (state.citySearchResults?.isNotEmpty == true) ...[
              SizedBox(height: 8.h),
              Container(
                constraints: BoxConstraints(maxHeight: 200.h),
                decoration: BoxDecoration(
                  color: appTheme.white_A700,
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(color: appTheme.blue_gray_100),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.black_900.withAlpha(26),
                      blurRadius: 8.h,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.citySearchResults!.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1.h,
                    color: appTheme.blue_gray_100,
                  ),
                  itemBuilder: (context, index) {
                    final city = state.citySearchResults![index];
                    return ListTile(
                      title: Text(
                        city,
                        style: TextStyleHelper.instance.body14RegularInter,
                      ),
                      onTap: () => ref
                          .read(activitySelectionNotifier.notifier)
                          .selectCity(city),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTimeSelectionRow() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(activitySelectionNotifier);
        return Row(
          children: [
            Expanded(
              child: CustomSearchView(
                controller: state.timeController,
                placeholder: '10:00',
                suffixIconPath: ImageConstant.imgSearchGreen500,
                readOnly: true,
                onTap: () => _showTimePicker(context),
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: CustomButton(
                text: 'Start now',
                backgroundColor: appTheme.green_500,
                textColor: appTheme.white_A700,
                onPressed: () {
                  ref.read(activitySelectionNotifier.notifier).setStartNow();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAIEnhancedDescriptionField() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(activitySelectionNotifier);
        return AIEnhancedTextField(
          controller: state.descriptionController!,
          hintText:
              'Share your interests, goals, or what makes you a great walking companion...',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
          onChanged: (value) {
            // Optional: react to edits if needed
          },
          validator: (value) => ref
              .read(activitySelectionNotifier.notifier)
              .validateDescription(value),
        );
      },
    );
  }

  Widget _buildAiAssistantChip() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.h),
        onTap: _showAiSuggestionsSheet,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
          decoration: BoxDecoration(
            color: appTheme.green_100,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 16.h, color: appTheme.green_600),
              SizedBox(width: 6.h),
              Text(
                'AI Assistant',
                style: TextStyleHelper.instance.body12MediumPoppins
                    .copyWith(color: appTheme.green_600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      ref.read(activitySelectionNotifier.notifier).setSelectedTime(picked);
    }
  }

  /// Bottom sheet with quick suggestions. Tapping a suggestion inserts it into
  /// the description text field and closes the sheet.
  void _showAiSuggestionsSheet() {
    final controller =
        ref.read(activitySelectionNotifier).descriptionController!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: appTheme.white_A700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.h,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: appTheme.blue_gray_100,
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'AI Suggestions',
                  style: TextStyleHelper.instance.title16SemiBoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                SizedBox(height: 8.h),
                ..._aiSuggestions.map(
                  (s) => Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.h),
                      onTap: () {
                        controller.text = s;
                        controller.selection = TextSelection.collapsed(
                          offset: controller.text.length,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                          color: appTheme.green_100,
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        child: Text(
                          s,
                          style: TextStyleHelper.instance.body14RegularInter
                              .copyWith(color: appTheme.blue_gray_800),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onTapContinue(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Get the current state
        final state = ref.read(activitySelectionNotifier);
        final selectedActivities = state.activitiesList
            ?.where((activity) => activity.isSelected ?? false)
            .toList() ?? [];

        if (selectedActivities.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one activity'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        // Prepare data to send to API
        final requestData = {
          'activities': selectedActivities.map((activity) => {
            'title': activity.title,
            'isSelected': activity.isSelected,
          }).toList(),
          'location': state.locationController?.text ?? '',
          'preferredTime': state.timeController?.text ?? '',
          'description': state.descriptionController?.text ?? '',
        };

        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Saving your preferences...'),
                ],
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 30), // Long duration, will be dismissed when done
            ),
          );
        }

        // Save to database via API
        final response = await html.HttpRequest.request(
          '/api/activity-preferences',
          method: 'POST',
          requestHeaders: {
            'Content-Type': 'application/json',
          },
          sendData: jsonEncode(requestData),
          withCredentials: true,
        );

        // Hide loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        if (response.status == 200) {
          // Success - update local state and navigate
          ref.read(activitySelectionNotifier.notifier).submitForm();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preferences saved successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            
            // Navigate to health data connection screen
            NavigatorService.pushNamed(AppRoutes.healthDataConnectionScreen);
          }
        } else {
          // Handle error
          throw Exception('Failed to save preferences: ${response.statusText}');
        }
      } catch (e) {
        print('Error saving activity preferences: $e');
        
        // Hide loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save preferences. Please try again.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => onTapContinue(context),
              ),
            ),
          );
        }
      }
    }
  }
}
