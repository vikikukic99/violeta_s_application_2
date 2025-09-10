import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class ChatListScreen extends StatelessWidget {
  /// Allows callers to hide a local bottom bar if the screen is already shown
  /// inside a shell that provides a global bottom navigation.
  final bool showLocalBottomBar;

  const ChatListScreen({
    Key? key,
    this.showLocalBottomBar = true, // keeps existing calls working
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = _mockChats;

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.white_A700,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Messages',
            style: TextStyleHelper.instance
                .title20BoldPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          actions: [
            IconButton(
              tooltip: 'Search',
              icon: Icon(Icons.search_rounded,
                  color: appTheme.blue_gray_900, size: 22.h),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'More',
              icon: Icon(Icons.more_vert,
                  color: appTheme.blue_gray_900, size: 22.h),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(height: 1.h, color: appTheme.blue_gray_100),
          ),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          physics: const BouncingScrollPhysics(),
          itemCount: chats.length,
          separatorBuilder: (_, __) => Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.blue_gray_100,
          ),
          itemBuilder: (context, index) {
            final item = chats[index];
            return InkWell(
              onTap: () {
                NavigatorService.pushNamed(
                  AppRoutes.chatConversationScreen,
                  arguments: {'name': item.name},
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      height: 44.h,
                      width: 44.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: appTheme.white_A700, width: 2.h),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath:
                              item.imagePath ?? ImageConstant.imgDivWhiteA70024x22,
                          height: 44.h,
                          width: 44.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.h),

                    // Name + last message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleHelper.instance
                                      .title16SemiBoldPoppins
                                      .copyWith(color: appTheme.blue_gray_900),
                                ),
                              ),
                              SizedBox(width: 8.h),
                              Text(
                                item.time,
                                style: TextStyleHelper.instance
                                    .body12RegularPoppins
                                    .copyWith(color: appTheme.blue_gray_300),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  item.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleHelper.instance
                                      .body14RegularPoppins
                                      .copyWith(color: appTheme.blue_gray_700),
                                ),
                              ),
                              if (item.unreadCount > 0) ...[
                                SizedBox(width: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.h, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: appTheme.green_500,
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  child: Text(
                                    '${item.unreadCount}',
                                    style: TextStyleHelper.instance
                                        .body12MediumPoppins
                                        .copyWith(color: appTheme.white_A700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Keep nav bar behavior the same as your app now; we don’t add another one here.
        // If you ever want a local bar on this screen specifically, you can wire it like:
        // bottomNavigationBar: showLocalBottomBar ? YourBottomBarWidget() : null,
      ),
    );
  }
}

/* --------------------------- Mock data model --------------------------- */

class _ChatListItem {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? imagePath;

  const _ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.imagePath, // Add this line
  });
}

final List<_ChatListItem> _mockChats = [
  _ChatListItem(
    name: 'Sarah Johnson',
    lastMessage: 'Hey! Are we still meeting for coffee tomorrow?',
    time: '9:24 AM',
    unreadCount: 2,
  ),
  _ChatListItem(
    name: 'David Chen',
    lastMessage: 'I\'ve sent you the project files.',
    time: 'Yesterday',
    unreadCount: 0,
  ),
  _ChatListItem(
    name: 'Emma Wilson',
    lastMessage: 'Don\'t forget about our team dinner on Friday!',
    time: 'Yesterday',
    unreadCount: 1,
  ),
  _ChatListItem(
    name: 'Michael Brown',
    lastMessage: 'Thanks for your help with the presentation!',
    time: 'Monday',
  ),
  _ChatListItem(
    name: 'Work Group',
    lastMessage: 'Alex: Can everyone send their updates by EOD?',
    time: 'Monday',
  ),
  _ChatListItem(
    name: 'Sophie Taylor',
    lastMessage: 'I\'ll call you later to discuss the details',
    time: 'Sunday',
  ),
  _ChatListItem(
    name: 'James Wilson',
    lastMessage: '📷 Photo',
    time: 'Last week',
  ),
  _ChatListItem(
    name: 'Robert Garcia',
    lastMessage: 'Let\'s catch up next weekend',
    time: 'Last week',
  ),
];