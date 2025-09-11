import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Create animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    _logoSlideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.bounceOut,
    ));
    
    _logoRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _titleSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutBack,
    ));
    
    _subtitleSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations with staggered delays
    _logoController.forward();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      _titleController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      _subtitleController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      _fadeController.forward();
      _scaleController.forward();
      _floatController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    _logoController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFEEF2FF),
                appTheme.white_A700,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      children: [
                        _buildStatusBar(),
                        SizedBox(height: 52.h),
                        _buildAppLogo(),
                        SizedBox(height: 8.h),
                        _buildAppTitle(),
                        SizedBox(height: 28.h),
                        _buildSubtitle(),
                        SizedBox(height: 28.h),
                        _buildMainImage(),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ),
              _buildGetStartedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyleHelper.instance.body14MediumPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              children: [
                Container(
                  width: 20.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray900,
                    height: 16.h,
                    width: 18.h,
                  ),
                ),
                SizedBox(width: 8.h),
                Container(
                  width: 20.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray90014x20,
                    height: 14.h,
                    width: 20.h,
                  ),
                ),
                SizedBox(width: 8.h),
                Container(
                  width: 18.h,
                  height: 16.h,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueGray90010x18,
                    height: 10.h,
                    width: 18.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_logoSlideAnimation.value, 0),
          child: Transform.scale(
            scale: _logoRotateAnimation.value,
            child: Container(
              width: 104.h,
              height: 104.h,
              child: Stack(
                children: [
                  Container(
                    width: 96.h,
                    height: 96.h,
                    margin: EdgeInsets.only(right: 8.h),
                    padding: EdgeInsets.all(28.h),
                    decoration: BoxDecoration(
                      color: appTheme.indigo_A400,
                      borderRadius: BorderRadius.circular(48.h),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.color190000,
                          offset: Offset(0, 10),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgVectorWhiteA700,
                      height: 36.h,
                      width: 22.h,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        color: appTheme.green_500,
                        borderRadius: BorderRadius.circular(20.h),
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.color190000,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgVectorWhiteA70014x16,
                        height: 14.h,
                        width: 16.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _titleSlideAnimation.value),
          child: Opacity(
            opacity: _titleController.value,
            child: Text(
              'WalkTalk',
              style: TextStyleHelper.instance.display36BoldPoppins.copyWith(height: 1.11),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _subtitleController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _subtitleSlideAnimation.value),
          child: Opacity(
            opacity: _subtitleController.value,
            child: Text(
              'Track your active lifestyle',
              style: TextStyleHelper.instance.title18RegularPoppins.copyWith(height: 1.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainImage() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_floatAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.img,
                            height: 350.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
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
    );
  }


  Widget _buildGetStartedButton() {
    return Container(
      width: 390.h,
      padding: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: appTheme.green_500,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.color190000,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            onTapGetStarted();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: TextStyleHelper.instance.title16SemiBoldPoppins
                    .copyWith(color: appTheme.white_A700, height: 1.5),
              ),
              SizedBox(width: 6.h),
              CustomImageView(
                imagePath: ImageConstant.imgVectorWhiteA70012x14,
                height: 12.h,
                width: 14.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapGetStarted() {
    NavigatorService.pushNamed(AppRoutes.registrationScreen);
  }
}
