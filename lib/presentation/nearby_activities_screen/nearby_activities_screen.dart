import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../chat_list_screen/chat_list_screen.dart';
import '../profile_screen/profile_screen.dart';
import './nearby_activities_initial_page.dart';

/// Tab shell that owns the single persistent bottom bar.
/// Tabs: 0 = Chat List, 1 = WalkTalk (Nearby), 2 = Profile
class NearbyActivitiesScreen extends ConsumerStatefulWidget {
  const NearbyActivitiesScreen({Key? key}) : super(key: key);

  @override
  NearbyActivitiesScreenState createState() => NearbyActivitiesScreenState();
}

class NearbyActivitiesScreenState
    extends ConsumerState<NearbyActivitiesScreen> {
  final GlobalKey<NavigatorState> _innerNavKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 1; // default to WalkTalk

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prefer an explicit 'tab' argument if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['tab'] is int) {
      final idx = args['tab'] as int;
      if (idx >= 0 && idx <= 2) _selectedIndex = idx;
    } else {
      // Infer from route name used to push this shell
      final name = ModalRoute.of(context)?.settings.name;
      if (name == AppRoutes.profileScreen) _selectedIndex = 2;
      if (name == AppRoutes.chatListScreen) _selectedIndex = 0;
      if (name == AppRoutes.nearbyActivitiesScreen) _selectedIndex = 1;
    }

    // Ensure inner navigator shows correct page after we resolve index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _switchTab(_selectedIndex, replaceStack: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Nested navigator that hosts the tab pages
        child: Navigator(
          key: _innerNavKey,
          initialRoute: _routeForIndex(_selectedIndex),
          onGenerateRoute: (settings) => PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (_, __, ___) => _getTabPage(settings.name!),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottomBar(context),
      ),
    );
  }

  /* ------------------------ Tab routing helpers ------------------------ */

  String _routeForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.chatListScreen;
      case 1:
        return AppRoutes.nearbyActivitiesScreenInitialPage;
      case 2:
      default:
        return AppRoutes.profileScreen;
    }
  }

  Widget _getTabPage(String route) {
    switch (route) {
      case AppRoutes.chatListScreen:
        // IMPORTANT: no local bottom bar here to avoid double bars
        return const ChatListScreen(showLocalBottomBar: false);
      case AppRoutes.profileScreen:
        // IMPORTANT: no local bottom bar here to avoid double bars
        return const ProfileScreen(showLocalBottomBar: false);
      case AppRoutes.nearbyActivitiesScreenInitialPage:
      default:
        return const NearbyActivitiesInitialPage();
    }
  }

  /* ------------------------ Persistent bottom bar ---------------------- */

  Widget _buildBottomBar(BuildContext context) {
    final items = <CustomBottomBarItem>[
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavChat,
        title: 'Chat',
        routeName: AppRoutes.chatListScreen,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgFrame, // Walk icon
        title: 'WalkTalk',
        routeName: AppRoutes.nearbyActivitiesScreenInitialPage,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavProfile,
        title: 'Profile',
        routeName: AppRoutes.profileScreen,
      ),
    ];

    return CustomBottomBar(
      selectedIndex: _selectedIndex,
      onChanged: (index) => _switchTab(index, replaceStack: true),
    );
  }

  /// Switch tabs inside the nested navigator.
  void _switchTab(int index, {bool replaceStack = false}) {
    if (index < 0 || index > 2) return;
    if (index == _selectedIndex && !replaceStack) return;

    setState(() => _selectedIndex = index);

    final routeName = _routeForIndex(index);
    if (replaceStack) {
      _innerNavKey.currentState
          ?.pushNamedAndRemoveUntil(routeName, (r) => false);
    } else {
      _innerNavKey.currentState?.pushNamed(routeName);
    }
  }
}
