import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/message_bubble_widget.dart';
import 'notifier/chat_conversation_notifier.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  const ChatConversationScreen({Key? key}) : super(key: key);

  @override
  ChatConversationScreenState createState() => ChatConversationScreenState();
}

class ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        body: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildMessagesList(context),
              ),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray_200,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              onTapBackButton(context);
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgButtonBlueGray700,
              height: 24.h,
              width: 14.h,
            ),
          ),
          SizedBox(width: 8.h),
          CustomImageView(
            imagePath: ImageConstant.imgDivGreenA700,
            height: 40.h,
            width: 40.h,
            radius: BorderRadius.circular(20.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: TextStyleHelper.instance.title16SemiBoldInter,
                ),
                Text(
                  'Online',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.green_A700),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.h),
          CustomImageView(
            imagePath: ImageConstant.imgButtonBlueGray70040x20,
            height: 40.h,
            width: 20.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMessagesList(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: appTheme.gray_50,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(chatConversationNotifier);

            return Column(
              children: [
                SizedBox(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray_200,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyleHelper.instance.body12RegularInter
                        .copyWith(color: appTheme.blue_gray_700),
                  ),
                ),
                SizedBox(height: 16.h),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.h);
                  },
                  itemCount: state.messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = state.messages![index];
                    return MessageBubbleWidget(message: message);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMessageInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
      ),
      child: Row(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(chatConversationNotifier);
                return CustomEditText(
                  controller: state.messageController,
                  hintText: 'Type a message...',
                  backgroundColor: appTheme.gray_100,
                  borderRadius: 22.h,
                  borderColor: appTheme.transparentCustom,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
                );
              },
            ),
          ),
          SizedBox(width: 16.h),
          GestureDetector(
            onTap: () {
              onTapSendMessage(context);
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgVector,
              height: 46.h,
              width: 28.h,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates back to the previous screen.
  void onTapBackButton(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.activityDetailScreen);
  }

  /// Handles sending a message.
  void onTapSendMessage(BuildContext context) {
    ref.read(chatConversationNotifier.notifier).sendMessage();
  }
}
