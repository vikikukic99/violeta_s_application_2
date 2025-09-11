import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/app_export.dart';
import './notifier/splash_notifier.dart';
import '../../widgets/custom_image_view.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _circleController;
  late AnimationController _bounceController;
  late Animation<double> _circleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers for circular walking motion
    _circleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Create circular animation (full 360-degree rotation)
    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // Full circle in radians
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.linear,
    ));
    
    // Create bounce animation for walking steps
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -8.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
    
    // Start circular walking animation
    _circleController.repeat();
    _bounceController.repeat(reverse: true);
    
    // Keep splash visible for 6 seconds to show animations, then navigate
    Future.delayed(const Duration(seconds: 6), () {
      ref.read(splashNotifier.notifier).navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.green_500,
        body: Consumer(
          builder: (context, ref, _) {
            ref.listen<SplashState>(splashNotifier, (prev, curr) {
              if (curr.shouldNavigate) {
                NavigatorService.pushNamedAndRemoveUntil(
                  AppRoutes.onboardingScreen,
                );
              }
            });

            return Center(
              child: SizedBox(
                width: 300.h,
                height: 300.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Central text content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'WalkTalk',
                          style: TextStyleHelper.instance.headline30BoldPoppins.copyWith(),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Connect through movement',
                          style: TextStyleHelper.instance.title16RegularPoppins.copyWith(
                            color: const Color(0xFFFFFFFF).withAlpha((0.8 * 255).toInt()),
                          ),
                        ),
                      ],
                    ),
                    // Multiple animated activity icons
                    AnimatedBuilder(
                      animation: _circleAnimation,
                      builder: (context, child) {
                        return AnimatedBuilder(
                          animation: _bounceAnimation,
                          builder: (context, child) {
                            double radius = 120.h;
                            
                            // Define activities with their icons and offsets
                            List<Map<String, dynamic>> activities = [
                              {
                                'icon': Icons.directions_run,
                                'offset': 0.0, // Running person
                                'color': Colors.orange,
                              },
                              {
                                'icon': Icons.directions_walk,
                                'offset': Math.pi / 2, // Walking person (90° ahead)
                                'color': Colors.blue,
                              },
                              {
                                'icon': Icons.directions_bike,
                                'offset': Math.pi, // Biking person (180° ahead)
                                'color': Colors.green,
                              },
                              {
                                'icon': Icons.pets,
                                'offset': 3 * Math.pi / 2, // Walking dog (270° ahead)
                                'color': Colors.purple,
                              },
                            ];
                            
                            return Stack(
                              children: activities.map((activity) {
                                double activityAngle = _circleAnimation.value + activity['offset'];
                                double x = radius * Math.cos(activityAngle);
                                double y = radius * Math.sin(activityAngle);
                                
                                return Transform.translate(
                                  offset: Offset(x, y + _bounceAnimation.value),
                                  child: Container(
                                    width: 55.h,
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: activity['color'].withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      activity['icon'],
                                      color: activity['color'],
                                      size: 28.h,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}