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
  
  late AnimationController _walkController;
  late AnimationController _bounceController;
  late Animation<double> _walkAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers for walking motion
    _walkController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create walking animation (horizontal movement)
    _walkAnimation = Tween<double>(
      begin: -50.0,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: _walkController,
      curve: Curves.easeInOut,
    ));
    
    // Create bounce animation (vertical movement)
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -15.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceOut,
    ));
    
    // Start walking animation
    _walkController.repeat(reverse: true);
    _bounceController.repeat(reverse: true);
    
    // Keep splash visible for 4 seconds, then navigate
    Future.delayed(const Duration(seconds: 4), () {
      ref.read(splashNotifier.notifier).navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _walkController.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Walking animated icon
                  AnimatedBuilder(
                    animation: _walkAnimation,
                    builder: (context, child) {
                      return AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_walkAnimation.value, _bounceAnimation.value),
                            child: Container(
                              width: 100.h,
                              height: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Lottie.asset(
                                'assets/anim/walktalk_running.json',
                                repeat: true,
                                fit: BoxFit.contain,
                                width: 70.h,
                                height: 70.h,
                                errorBuilder: (context, err, stack) {
                                  // Walking person icon fallback
                                  return Icon(
                                    Icons.directions_walk,
                                    color: appTheme.green_500,
                                    size: 50.h,
                                  );
                                },
                              ),
                            ),
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