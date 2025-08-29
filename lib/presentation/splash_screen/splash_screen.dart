import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/splash_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _logoAnimationController, curve: Curves.elasticOut));

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _logoAnimationController, curve: Curves.easeIn));
  }

  void _startSplashSequence() {
    _logoAnimationController.forward();

    Future.delayed(Duration(seconds: 3), () {
      ref.read(splashNotifier.notifier).navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.green_500,
            body: Consumer(builder: (context, ref, _) {
              final state = ref.watch(splashNotifier);

              ref.listen<SplashState>(splashNotifier, (previous, current) {
                if (current.shouldNavigate) {
                  NavigatorService.pushNamedAndRemoveUntil(
                      AppRoutes.onboardingScreen);
                }
              });

              return Container(
                  width: double.maxFinite,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogoSection(),
                        SizedBox(height: 10.h),
                        _buildTitleText(),
                        SizedBox(height: 2.h),
                        _buildSubtitleText(),
                      ]));
            })));
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
        animation: _logoAnimationController,
        builder: (context, child) {
          return Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Container(
                      width: 96.h,
                      height: 96.h,
                      decoration: BoxDecoration(
                          color: appTheme.white_A700,
                          borderRadius: BorderRadius.circular(48.h)),
                      child: Center(
                          child: CustomImageView(
                              imagePath: ImageConstant.imgIGreen500,
                              height: 40.h,
                              width: 22.h)))));
        });
  }

  Widget _buildTitleText() {
    return Text(
        // Modified: Added missing parenthesis and semicolon
        'WalkTalk',
        style: TextStyleHelper.instance.headline30BoldPoppins.copyWith());
  }

  Widget _buildSubtitleText() {
    return Text(
        // Modified: Added missing parenthesis and semicolon
        'Connect through movement',
        style: TextStyleHelper.instance.title16RegularPoppins.copyWith(
            color: Color(0xFFFFFFFF).withAlpha((0.8 * 255)
                .toInt()))); // Modified: Removed invalid height parameter from copyWith
  }
}
