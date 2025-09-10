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

class SplashScreenState extends ConsumerState<SplashScreen> {
  // Set this to the EXACT path of your JSON in pubspec.yaml
  static const String kLottiePath = 'assets/anim/walktalk_running.json';

  @override
  void initState() {
    super.initState();
    // Keep splash visible for 5 seconds, then navigate
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
                  // --- Your requested snippet (with fallback) ---
                  ClipOval(
                    child: Container(
                      width: 96.h,
                      height: 96.h,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        kLottiePath,
                        repeat: true,
                        fit: BoxFit.contain,
                        errorBuilder: (context, err, stack) {
                          // Fallback to static icon if the Lottie fails to load
                          return CustomImageView(
                            imagePath: ImageConstant.imgIGreen500,
                            height: 40.h,
                            width: 40.h,
                            fit: BoxFit.contain,
                          );
                        },
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