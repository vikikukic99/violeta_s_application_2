import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/app_export.dart';
import './notifier/splash_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Show the splash for 5 seconds before navigating away
    Future.delayed(const Duration(seconds: 5), () {
      ref.read(splashNotifier.notifier).navigateToNextScreen();
    });
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
                  // White circular badge containing the walking Lottie
                  ClipOval(
                    child: Container(
                      width: 96.h,
                      height: 96.h,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/anim/walktalk_running.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
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