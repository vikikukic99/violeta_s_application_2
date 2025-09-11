import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/health_dashboard_model.dart';

class WeeklyProgressChartWidget extends StatelessWidget {
  final List<DailyHealthDataModel> weeklyData;
  final String selectedMetric;
  final Function(String)? onMetricChanged;
  final VoidCallback? onViewDetails;

  const WeeklyProgressChartWidget({
    Key? key,
    required this.weeklyData,
    this.selectedMetric = 'steps',
    this.onMetricChanged,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.h,
                    height: 32.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: appTheme.blue_50,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFrameGray600,
                      height: 20.h,
                      width: 20.h,
                      color: appTheme.blue_A700,
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    'Weekly Progress',
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onViewDetails,
                child: Text(
                  'View Details',
                  style: TextStyleHelper.instance.body14MediumPoppins
                      .copyWith(color: appTheme.green_500),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Metric selector
          _MetricSelectorWidget(
            selectedMetric: selectedMetric,
            onMetricChanged: onMetricChanged,
          ),
          SizedBox(height: 16.h),

          // Chart
          if (weeklyData.isNotEmpty) ...[
            _WeeklyChart(
              data: weeklyData,
              selectedMetric: selectedMetric,
            ),
          ] else ...[
            _EmptyChartState(),
          ],
        ],
      ),
    );
  }
}

class _MetricSelectorWidget extends StatelessWidget {
  final String selectedMetric;
  final Function(String)? onMetricChanged;

  const _MetricSelectorWidget({
    Key? key,
    required this.selectedMetric,
    this.onMetricChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metrics = [
      {'key': 'steps', 'label': 'Steps', 'color': appTheme.green_500},
      {'key': 'calories', 'label': 'Calories', 'color': appTheme.amber_500},
      {'key': 'distance', 'label': 'Distance', 'color': appTheme.teal_400},
      {'key': 'activeMinutes', 'label': 'Active', 'color': appTheme.blue_500},
    ];

    return Row(
      children: metrics.map((metric) {
        final isSelected = selectedMetric == metric['key'];
        return Expanded(
          child: GestureDetector(
            onTap: () => onMetricChanged?.call(metric['key'] as String),
            child: Container(
              margin: EdgeInsets.only(right: 8.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
              decoration: BoxDecoration(
                color: isSelected 
                    ? (metric['color'] as Color).withAlpha(25)
                    : appTheme.gray_50,
                borderRadius: BorderRadius.circular(8.h),
                border: Border.all(
                  color: isSelected 
                      ? (metric['color'] as Color)
                      : appTheme.gray_200,
                ),
              ),
              child: Text(
                metric['label'] as String,
                textAlign: TextAlign.center,
                style: TextStyleHelper.instance.body12MediumInter.copyWith(
                  color: isSelected 
                      ? (metric['color'] as Color)
                      : appTheme.gray_600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<DailyHealthDataModel> data;
  final String selectedMetric;

  const _WeeklyChart({
    Key? key,
    required this.data,
    required this.selectedMetric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartData = _getChartData();
    final maxValue = chartData.isEmpty ? 1.0 : chartData.reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 120.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final value = index < chartData.length ? chartData[index] : 0.0;
          final height = maxValue > 0 ? (value / maxValue) * 100.h : 0.0;
          final dayName = _getDayName(index);
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Value label
                  if (value > 0) ...[
                    Text(
                      _formatValue(value),
                      style: TextStyleHelper.instance.body12RegularInter
                          .copyWith(color: appTheme.gray_600),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  
                  // Bar
                  Container(
                    width: double.infinity,
                    height: height.clamp(4.h, 100.h),
                    decoration: BoxDecoration(
                      color: _getMetricColor().withAlpha(200),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // Day label
                  Text(
                    dayName,
                    style: TextStyleHelper.instance.body10RegularInter
                        .copyWith(color: appTheme.gray_600),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  List<double> _getChartData() {
    if (data.isEmpty) return [];
    
    return data.map((dayData) {
      switch (selectedMetric) {
        case 'steps':
          return dayData.steps.toDouble();
        case 'calories':
          return dayData.calories.toDouble();
        case 'distance':
          return dayData.distance;
        case 'activeMinutes':
          return dayData.activeMinutes.toDouble();
        default:
          return 0.0;
      }
    }).toList();
  }

  Color _getMetricColor() {
    switch (selectedMetric) {
      case 'steps':
        return appTheme.green_500;
      case 'calories':
        return appTheme.amber_500;
      case 'distance':
        return appTheme.teal_400;
      case 'activeMinutes':
        return appTheme.blue_A700;
      default:
        return appTheme.gray_600;
    }
  }

  String _getDayName(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  String _formatValue(double value) {
    if (selectedMetric == 'distance') {
      return '${value.toStringAsFixed(1)}km';
    } else if (selectedMetric == 'steps' && value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return value.toInt().toString();
    }
  }
}

class _EmptyChartState extends StatelessWidget {
  const _EmptyChartState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.h,
            height: 48.h,
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: appTheme.gray_100,
              borderRadius: BorderRadius.circular(24.h),
            ),
            child: CustomImageView(
              imagePath: ImageConstant.imgFrameGray600,
              height: 24.h,
              width: 24.h,
              color: appTheme.gray_600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'No Data Available',
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.blue_gray_800),
          ),
          SizedBox(height: 4.h),
          Text(
            'Start tracking to see your progress',
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(color: appTheme.gray_600),
          ),
        ],
      ),
    );
  }
}