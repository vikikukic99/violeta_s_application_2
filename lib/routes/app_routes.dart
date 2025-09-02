import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/activity_selection_screen/activity_selection_screen.dart';
import '../presentation/health_data_connection_screen/health_data_connection_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/edit_profile_screen/edit_profile_screen.dart';
import '../presentation/nearby_activities_screen/nearby_activities_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/payment_methods_screen/payment_methods_screen.dart';
import '../presentation/privacy_settings_screen/privacy_settings_screen.dart';
import '../presentation/chat_conversation_screen/chat_conversation_screen.dart';
import '../presentation/activity_detail_screen/activity_detail_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/chat_list_screen/chat_list_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String onboardingScreen = '/onboarding_screen';
  static const String registrationScreen = '/registration_screen';
  static const String activitySelectionScreen = '/activity_selection_screen';
  static const String healthDataConnectionScreen =
      '/health_data_connection_screen';

  static const String profileScreen = '/profile_screen';
  static const String editProfileScreen = '/edit_profile_screen';

  static const String nearbyActivitiesScreen = '/nearby_activities_screen';
  static const String nearbyActivitiesScreenInitialPage =
      '/nearby_activities_screen_initial_page';

  static const String loginScreen = '/login_screen';
  static const String paymentMethodsScreen = '/payment_methods_screen';
  static const String privacySettingsScreen = '/privacy_settings_screen';

  static const String chatConversationScreen = '/chat_conversation_screen';
  static const String chatListScreen = '/chat_list_screen';

  static const String activityDetailScreen = '/activity_detail_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
        splashScreen: (context) => SplashScreen(),
        onboardingScreen: (context) => OnboardingScreen(),
        registrationScreen: (context) => RegistrationScreen(),
        activitySelectionScreen: (context) => ActivitySelectionScreen(),
        healthDataConnectionScreen: (context) => HealthDataConnectionScreen(),
        profileScreen: (context) => ProfileScreen(),
        editProfileScreen: (context) => EditProfileScreen(),
        nearbyActivitiesScreen: (context) => NearbyActivitiesScreen(),
        loginScreen: (context) => LoginScreen(),
        paymentMethodsScreen: (context) => PaymentMethodsScreen(),
        privacySettingsScreen: (context) => PrivacySettingsScreen(),
        chatConversationScreen: (context) => ChatConversationScreen(),
        chatListScreen: (context) => const ChatListScreen(),
        activityDetailScreen: (context) => ActivityDetailScreen(),
        appNavigationScreen: (context) => AppNavigationScreen(),
        initialRoute: (context) => AppNavigationScreen(),
      };
}
