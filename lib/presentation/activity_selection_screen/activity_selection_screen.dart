import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_search_view.dart';

import 'widgets/activity_card_widget.dart';
import 'widgets/ai_enhanced_text_field.dart';
import 'notifier/activity_selection_notifier.dart';

class ActivitySelectionScreen extends ConsumerStatefulWidget {
  const ActivitySelectionScreen({Key? key}) : super(key: key);

  @override
  ActivitySelectionScreenState createState() => ActivitySelectionScreenState();
}

class ActivitySelectionScreenState
    extends ConsumerState<ActivitySelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activitySelectionNotifier);

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
                // Title
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

                // Activities grid
                SizedBox(height: 24.h),
                _buildActivitiesGrid(),

                // Location
                SizedBox(height: 24.h),
                Text(
                  'Location',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 8.h),
                _buildLocationField(),

                // Start time
                SizedBox(height: 24.h),
                Text(
                  'Start time',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 12.h),
                _buildTimeSelectionRow(),

                // About you
                SizedBox(height: 24.h),
                Text(
                  'Tell us more about you.',
                  style: TextStyleHelper.instance.headline24BoldInter,
                ),
                SizedBox(height: 12.h),

                // AI enhanced description field
                // NOTE: Only ONE AI entry point lives inside this widget (no duplicate button below).
                AIEnhancedTextField(
                  controller: state.descriptionController!,
                  hintText:
                      'Share your interests, goals, or what makes you a great walking companion...',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
                  onChanged: (v) {},
                  validator: (value) => ref
                      .read(activitySelectionNotifier.notifier)
                      .validateDescription(value),
                ),

                SizedBox(height: 40.h),

                // Continue CTA (frameless right icon is handled in CustomButton via rightIconWidget)
                CustomButton(
                  text: 'Continue',
                  backgroundColor: appTheme.green_500,
                  textColor: appTheme.white_A700,
                  rightIconWidget: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: () => onTapContinue(context),
                  width: double.infinity,
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
                              height: 18.h,
                              width: 18.h,
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

            // Error chip
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
                      onTap: notifier.clearLocationError,
                      child: Icon(Icons.close,
                          color: appTheme.colorFFEF44, size: 16.h),
                    ),
                  ],
                ),
              ),
            ],

            // City suggestions dropdown
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
                onPressed: () =>
                    ref.read(activitySelectionNotifier.notifier).setStartNow(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      ref.read(activitySelectionNotifier.notifier).setSelectedTime(picked);
    }
  }

  void onTapContinue(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(activitySelectionNotifier.notifier).submitForm();
      NavigatorService.pushNamed(AppRoutes.healthDataConnectionScreen);
    }
  }
}
