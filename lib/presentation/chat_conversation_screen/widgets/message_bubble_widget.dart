import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  final MessageModel message;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.isSentByMe ?? false
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!(message.isSentByMe ?? false)) ...[
          CustomImageView(
            imagePath: message.avatarImage ?? ImageConstant.imgImg,
            height: 32.h,
            width: 32.h,
            radius: BorderRadius.circular(16.h),
          ),
          SizedBox(width: 12.h),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: message.isSentByMe ?? false
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
                decoration: BoxDecoration(
                  color: message.isSentByMe ?? false
                      ? Color(0xFF4CAF50)
                      : appTheme.white_A700,
                  borderRadius: BorderRadius.circular(8.h),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.color0C0000,
                      offset: Offset(0, 1),
                      blurRadius: 2.h,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.text?.isNotEmpty == true)
                      Text(
                        message.text ?? '',
                        style: TextStyleHelper.instance.title16RegularInter
                            .copyWith(
                                color: message.isSentByMe ?? false
                                    ? Color(0xFFFFFFFF)
                                    : appTheme.blue_gray_900,
                                height: 1.25),
                      ),
                    if (message.hasAttachment ?? false) ...[
                      if (message.text?.isNotEmpty == true)
                        SizedBox(height: 8.h),
                      Container(
                        width: 244.h,
                        height: 128.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray_100,
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Center(
                          child: CustomImageView(
                            imagePath: ImageConstant.imgIBlueGray300,
                            height: 36.h,
                            width: 30.h,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.timestamp ?? '',
                    style: TextStyleHelper.instance.body12RegularInter,
                  ),
                  if ((message.isSentByMe ?? false) &&
                      (message.isDelivered ?? false)) ...[
                    // Modified: Added null safety handling
                    SizedBox(width: 2.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgFrameGreen500,
                      height: 12.h,
                      width: 10.h,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
