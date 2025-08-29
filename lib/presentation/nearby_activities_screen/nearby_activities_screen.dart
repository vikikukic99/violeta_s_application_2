import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../chat_conversation_screen/chat_conversation_screen.dart';
import '../profile_screen/profile_screen.dart';
import './nearby_activities_initial_page.dart';

// Modified: Added import for ChatConversationScreen
// Modified: Added import for ProfileScreen

class NearbyActivitiesScreen extends ConsumerStatefulWidget {
  const NearbyActivitiesScreen({Key? key}) : super(key: key);

  @override
  NearbyActivitiesScreenState createState() => NearbyActivitiesScreenState();
}

class NearbyActivitiesScreenState
    extends ConsumerState<NearbyActivitiesScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.nearbyActivitiesScreenInitialPage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, a1, a2) =>
                getCurrentPage(context, routeSetting.name!),
            transitionDuration: Duration(seconds: 0),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    List<CustomBottomBarItem> bottomBarItemList = [
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavChat,
        title: 'Chat',
        routeName: AppRoutes.chatConversationScreen,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgFrame,
        title: 'WalkTalk',
        routeName: AppRoutes.nearbyActivitiesScreenInitialPage,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavProfile,
        title: 'Profile',
        routeName: AppRoutes.profileScreen,
      ),
    ];

    int selectedIndex = 1;

    return CustomBottomBar(
      bottomBarItemList: bottomBarItemList,
      onChanged: (index) {
        selectedIndex = index;
        var bottomBarItem = bottomBarItemList[index];
        navigatorKey.currentState?.pushNamed(bottomBarItem.routeName);
      },
      selectedIndex: selectedIndex,
      backgroundColor: appTheme.white_A700,
      padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 14.h),
      height: 84.h,
    );
  }

  Widget getCurrentPage(BuildContext context, String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.nearbyActivitiesScreenInitialPage:
        return NearbyActivitiesInitialPage();
      case AppRoutes.chatConversationScreen:
        return ChatConversationScreen(); // Modified: Changed to proper widget instantiation
      case AppRoutes.profileScreen:
        return ProfileScreen(); // Modified: Changed to proper widget instantiation
      default:
        return Container();
    }
  }
}
