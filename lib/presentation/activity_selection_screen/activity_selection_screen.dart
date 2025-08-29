import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_search_view.dart';
import './widgets/activity_card_widget.dart';
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
                _buildActivitiesGrid(),
                SizedBox(height: 24.h),
                Text(
                  'Location',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 8.h),
                _buildLocationField(),
                SizedBox(height: 24.h),
                Text(
                  'Start time',
                  style: TextStyleHelper.instance.body14MediumPoppins,
                ),
                SizedBox(height: 12.h),
                _buildTimeSelectionRow(),
                SizedBox(height: 24.h),
                Text(
                  'Tell us more about you.',
                  style: TextStyleHelper.instance.headline24BoldInter,
                ),
                SizedBox(height: 16.h),
                _buildDescriptionField(),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Continue',
                  backgroundColor: appTheme.green_500,
                  textColor: appTheme.white_A700,
                  rightIcon: ImageConstant.imgI,
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
    return CustomEditText(
      hintText: 'Find your city',
      rightIcon: ImageConstant.imgDivGreen500,
      borderColor: appTheme.blue_gray_100,
      backgroundColor: appTheme.white_A700,
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

  Widget _buildDescriptionField() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(activitySelectionNotifier);
        return CustomEditText(
          controller: state.descriptionController,
          hintText: 'Text input...',
          borderColor: appTheme.blue_gray_100,
          backgroundColor: appTheme.white_A700,
          hintTextColor: appTheme.gray_600,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.h, vertical: 24.h),
          validator: (value) => ref
              .read(activitySelectionNotifier.notifier)
              .validateDescription(value),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) async {
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
