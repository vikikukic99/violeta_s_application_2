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
  // Set this to the EXACT path of your JSON in pubspec.yaml
  static const String kLottiePath = 'assets/anim/walktalk_running.json';
  
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Create animations
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // Full rotation
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _scaleController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    
    // Keep splash visible for 5 seconds, then navigate
    Future.delayed(const Duration(seconds: 5), () {
      ref.read(splashNotifier.notifier).navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated icon with multiple effects
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value * _pulseAnimation.value,
                                child: Transform.rotate(
                                  angle: _rotationAnimation.value,
                                  child: Container(
                                    width: 120.h,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 20 * _pulseAnimation.value,
                                          spreadRadius: 10 * _pulseAnimation.value,
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 96.h,
                                      height: 96.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Lottie.asset(
                                        kLottiePath,
                                        repeat: true,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, err, stack) {
                                          // Animated fallback icon
                                          return Transform.rotate(
                                            angle: -_rotationAnimation.value, // Counter-rotate to keep icon upright
                                            child: CustomImageView(
                                              imagePath: ImageConstant.imgIGreen500,
                                              height: 50.h,
                                              width: 50.h,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
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
            );
          },
        ),
      ),
    );
  }
}