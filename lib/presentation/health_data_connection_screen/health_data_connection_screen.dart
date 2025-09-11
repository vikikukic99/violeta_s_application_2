import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming these are your project's custom imports.
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_edit_text.dart';
import 'notifier/health_data_connection_notifier.dart';

class HealthDataConnectionScreen extends ConsumerStatefulWidget {
  const HealthDataConnectionScreen({super.key});

  @override
  HealthDataConnectionScreenState createState() =>
      HealthDataConnectionScreenState();
}

class HealthDataConnectionScreenState
    extends ConsumerState<HealthDataConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthDataConnectionNotifier);
    
    // Listen for state changes and handle navigation
    ref.listen<HealthDataConnectionState>(
      healthDataConnectionNotifier,
      (previous, next) {
        if (next.isSuccess && (next.isConnected || next.isManualDataSaved)) {
          // Navigate to profile screen after successful connection
          Future.delayed(Duration(milliseconds: 1000), () {
            NavigatorService.pushNamed(AppRoutes.profileScreen);
          });
        }
      },
    );
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: Container(
              margin: EdgeInsets.all(16.h),
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.h),
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(16.h),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 32.h),
                    _buildTitleAndDescription(),
                    if (state.errorMessage != null) ...[
                      SizedBox(height: 16.h),
                      _buildErrorMessage(state.errorMessage!),
                    ],
                    if (state.isConnected || state.isManualDataSaved) ...[
                      SizedBox(height: 16.h),
                      _buildSuccessMessage(),
                    ],
                    SizedBox(height: 28.h),
                    _buildHealthAppsSection(),
                    SizedBox(height: 30.h),
                    _buildBenefitsSection(),
                    SizedBox(height: 32.h),
                    _buildPrivacyNote(),
                    SizedBox(height: 38.h),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget: App Logo and Name
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrame,
          height: 30.h,
          width: 18.h,
        ),
        SizedBox(width: 8.h),
        Text(
          'WalkTalk',
          style: TextStyleHelper.instance.headline24BoldPoppins,
        ),
      ],
    );
  }

  /// Section Widget: Main Title and Description
  Widget _buildTitleAndDescription() {
    return Column(
      children: [
        Text(
          'Connect Health Data',
          style: TextStyleHelper.instance.headline24BoldInter,
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            'Connect your health app to track your steps, distance, and activity automatically. WalkTalk uses this data to provide personalized insights and challenges.',
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.title16RegularInter.copyWith(
              color: appTheme.blue_gray_700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget: Health App Icons
  Widget _buildHealthAppsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        _buildHealthAppItem(
          iconPath: ImageConstant.imgIWhiteA70064x64,
          backgroundColor: appTheme.black_900,
          label: 'Google Fit',
        ),
        SizedBox(width: 16.h),
        _buildHealthAppItem(
          iconPath: ImageConstant.imgI64x64,
          backgroundColor: appTheme.blue_A200,
          label: 'Manual Entry',
        ),
        SizedBox(width: 16.h),
        _buildHealthAppItem(
          iconPath: ImageConstant.imgI3,
          backgroundColor: appTheme.teal_A700,
          label: 'Samsung Health',
        ),
      ],
    );
  }

  /// Reusable Widget for a single health app item.
  Widget _buildHealthAppItem({
    required String iconPath,
    required Color backgroundColor,
    required String label,
  }) {
    return SizedBox(
      width: 90.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIconButton(
            iconPath: iconPath,
            backgroundColor: backgroundColor,
            size: 64.h,
            borderRadius: 12.h,
            padding: EdgeInsets.all(16.h),
            onTap: () {
              _onTapHealthApp(label);
            },
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyleHelper.instance.body14RegularInter,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  /// Section Widget: Benefits List
  Widget _buildBenefitsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.gray_50,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benefits of connecting:',
            style: TextStyleHelper.instance.title16SemiBoldInter,
          ),
          SizedBox(height: 16.h),
          _buildBenefitItem('Automatic step and activity tracking'),
          SizedBox(height: 12.h),
          _buildBenefitItem('Personalized fitness insights'),
          SizedBox(height: 12.h),
          _buildBenefitItem('Compete in challenges with friends'),
        ],
      ),
    );
  }

  /// Reusable Widget for a single benefit item.
  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrameTeal400,
          height: 16.h,
          width: 14.h,
        ),
        SizedBox(width: 12.h),
        // Expanded ensures the text wraps if it's too long
        Expanded(
          child: Text(
            text,
            style: TextStyleHelper.instance.title16RegularInter.copyWith(
              color: appTheme.blue_gray_700,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget: Privacy Note
  Widget _buildPrivacyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgFrameGray600,
          height: 12.h,
          width: 10.h,
          margin: EdgeInsets.only(top: 2.h),
        ),
        SizedBox(width: 8.h),
        Text(
          'Your health data is private and secure. We only access the data you allow.',
          style: TextStyleHelper.instance.body12RegularInter,
        ),
      ],
    );
  }

  /// Section Widget: Action Buttons
  Widget _buildActionButtons() {
    final state = ref.watch(healthDataConnectionNotifier);
    
    return Column(
      children: [
        CustomButton(
          text: state.isLoading ? 'Connecting...' : (state.selectedApp != null ? 'Connect ${state.selectedApp}' : 'Set Health Goals'),
          leftIcon: state.isLoading ? null : ImageConstant.imgIWhiteA70024x20,
          backgroundColor: appTheme.green_500,
          textColor: appTheme.white_A700,
          borderRadius: 12.h,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.h),
          onPressed: state.isLoading ? null : () {
            _onTapConnectNow();
          },
        ),
        if (state.isLoading) ...[
          SizedBox(height: 16.h),
          SizedBox(
            width: 20.h,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.green_500),
            ),
          ),
        ],
        SizedBox(height: 16.h),
        CustomButton(
          text: 'Skip for Now',
          backgroundColor: appTheme.white_A700,
          textColor: appTheme.blue_gray_700,
          borderColor: appTheme.blue_gray_100,
          borderWidth: 1.h,
          borderRadius: 12.h,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.h),
          onPressed: state.isLoading ? null : () {
            _onTapSkipForNow();
          },
        ),
      ],
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.red_50,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: appTheme.red_300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: appTheme.red_500,
            size: 20.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              message,
              style: TextStyleHelper.instance.body14RegularInter.copyWith(
                color: appTheme.red_700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(healthDataConnectionNotifier.notifier).clearError();
            },
            child: Icon(
              Icons.close,
              color: appTheme.red_500,
              size: 20.h,
            ),
          ),
        ],
      ),
    );
  }

  /// Build success message widget
  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.green_50,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: appTheme.green_300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: appTheme.green_500,
            size: 20.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              'Health data connected successfully! Redirecting to your profile...',
              style: TextStyleHelper.instance.body14RegularInter.copyWith(
                color: appTheme.green_700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Functions ---
  void _onTapConnectNow() {
    final state = ref.read(healthDataConnectionNotifier);
    if (state.selectedApp == 'Google Fit') {
      ref.read(healthDataConnectionNotifier.notifier).connectGoogleFit();
    } else {
      _showManualDataInputDialog();
    }
  }

  void _onTapHealthApp(String appName) {
    ref.read(healthDataConnectionNotifier.notifier).selectHealthApp(appName);
  }

  void _onTapSkipForNow() {
    ref.read(healthDataConnectionNotifier.notifier).skipConnection();
    NavigatorService.pushNamed(AppRoutes.profileScreen);
  }

  void _showManualDataInputDialog() {
    showDialog(
      context: context,
      builder: (context) => _ManualHealthDataDialog(
        onSave: (data) {
          Navigator.of(context).pop();
          ref.read(healthDataConnectionNotifier.notifier).saveManualHealthData(
            dailyStepsGoal: data['dailyStepsGoal'] ?? 10000,
            weeklyWorkoutsGoal: data['weeklyWorkoutsGoal'] ?? 3,
            dailyCaloriesGoal: data['dailyCaloriesGoal'],
            weight: data['weight'],
            age: data['age'],
            height: data['height'],
            gender: data['gender'],
            activityLevel: data['activityLevel'],
          );
        },
      ),
    );
  }
}

class _ManualHealthDataDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _ManualHealthDataDialog({required this.onSave});

  @override
  _ManualHealthDataDialogState createState() => _ManualHealthDataDialogState();
}

class _ManualHealthDataDialogState extends State<_ManualHealthDataDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dailyStepsController = TextEditingController(text: '10000');
  final _weeklyWorkoutsController = TextEditingController(text: '3');
  final _dailyCaloriesController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedActivityLevel;
  
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active', 
    'Very Active',
    'Extremely Active'
  ];
  
  @override
  void dispose() {
    _dailyStepsController.dispose();
    _weeklyWorkoutsController.dispose();
    _dailyCaloriesController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 400.h,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Set Health Goals',
                        style: TextStyleHelper.instance.headline20BoldInter,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  // Required Goals Section
                  Text(
                    'Daily Goals (Required)',
                    style: TextStyleHelper.instance.title16SemiBoldInter,
                  ),
                  SizedBox(height: 16.h),
                  
                  // Daily Steps Goal
                  _buildNumberField(
                    controller: _dailyStepsController,
                    label: 'Daily Steps Goal',
                    hint: '10000',
                    isRequired: true,
                  ),
                  SizedBox(height: 16.h),
                  
                  // Weekly Workouts Goal
                  _buildNumberField(
                    controller: _weeklyWorkoutsController,
                    label: 'Weekly Workouts Goal',
                    hint: '3',
                    isRequired: true,
                  ),
                  SizedBox(height: 24.h),
                  
                  // Optional Personal Info Section
                  Text(
                    'Personal Information (Optional)',
                    style: TextStyleHelper.instance.title16SemiBoldInter,
                  ),
                  SizedBox(height: 16.h),
                  
                  // Age and Gender Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          controller: _ageController,
                          label: 'Age',
                          hint: '25',
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Gender',
                          value: _selectedGender,
                          items: _genders,
                          onChanged: (value) => setState(() => _selectedGender = value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  // Height and Weight Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          controller: _heightController,
                          label: 'Height (cm)',
                          hint: '170',
                          isDecimal: true,
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Expanded(
                        child: _buildNumberField(
                          controller: _weightController,
                          label: 'Weight (kg)',
                          hint: '70',
                          isDecimal: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  // Activity Level
                  _buildDropdownField(
                    label: 'Activity Level',
                    value: _selectedActivityLevel,
                    items: _activityLevels,
                    onChanged: (value) => setState(() => _selectedActivityLevel = value),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Daily Calories Goal
                  _buildNumberField(
                    controller: _dailyCaloriesController,
                    label: 'Daily Calories Goal (Optional)',
                    hint: '2000',
                  ),
                  SizedBox(height: 32.h),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          backgroundColor: appTheme.white_A700,
                          textColor: appTheme.blue_gray_700,
                          borderColor: appTheme.blue_gray_300,
                          borderWidth: 1.h,
                          borderRadius: 8.h,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Expanded(
                        child: CustomButton(
                          text: 'Save Goals',
                          backgroundColor: appTheme.green_500,
                          textColor: appTheme.white_A700,
                          borderRadius: 8.h,
                          onPressed: _saveHealthData,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    bool isDecimal = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyleHelper.instance.body14SemiBoldInter.copyWith(
            color: appTheme.blue_gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: isDecimal ? TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
          inputFormatters: isDecimal 
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyleHelper.instance.body14RegularInter.copyWith(
              color: appTheme.blue_gray_400,
            ),
            filled: true,
            fillColor: appTheme.white_A700,
            contentPadding: EdgeInsets.all(12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.blue_gray_300,
                width: 1.h,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.blue_gray_300,
                width: 1.h,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.green_500,
                width: 2.h,
              ),
            ),
          ),
          validator: isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            final number = isDecimal ? double.tryParse(value) : int.tryParse(value);
            if (number == null || number <= 0) {
              return 'Please enter a valid number';
            }
            return null;
          } : null,
        ),
      ],
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.instance.body14SemiBoldInter.copyWith(
            color: appTheme.blue_gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: appTheme.blue_gray_300),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select $label',
                style: TextStyleHelper.instance.body14RegularInter.copyWith(
                  color: appTheme.blue_gray_400,
                ),
              ),
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyleHelper.instance.body14RegularInter,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  void _saveHealthData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final data = <String, dynamic>{
      'dailyStepsGoal': int.tryParse(_dailyStepsController.text),
      'weeklyWorkoutsGoal': int.tryParse(_weeklyWorkoutsController.text),
    };
    
    if (_dailyCaloriesController.text.isNotEmpty) {
      data['dailyCaloriesGoal'] = int.tryParse(_dailyCaloriesController.text);
    }
    
    if (_weightController.text.isNotEmpty) {
      data['weight'] = double.tryParse(_weightController.text);
    }
    
    if (_ageController.text.isNotEmpty) {
      data['age'] = int.tryParse(_ageController.text);
    }
    
    if (_heightController.text.isNotEmpty) {
      data['height'] = double.tryParse(_heightController.text);
    }
    
    if (_selectedGender != null) {
      data['gender'] = _selectedGender!.toLowerCase();
    }
    
    if (_selectedActivityLevel != null) {
      data['activityLevel'] = _selectedActivityLevel!.toLowerCase().replaceAll(' ', '_');
    }
    
    widget.onSave(data);
  }
}