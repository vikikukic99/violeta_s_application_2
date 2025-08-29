import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/blocked_user_item_model.dart';

class BlockedUserItemWidget extends StatelessWidget {
  final BlockedUserItemModel blockedUser;
  final VoidCallback? onUnblockTap;

  const BlockedUserItemWidget({
    Key? key,
    required this.blockedUser,
    this.onUnblockTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray_100,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.h),
            ),
            child: Image.asset(
              blockedUser.userImage ?? '',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blockedUser.userName ?? '',
                  style: TextStyleHelper.instance.title16MediumInter
                      .copyWith(color: appTheme.blue_gray_900),
                ),
                if (blockedUser.blockedDate?.isNotEmpty == true)
                  Text(
                    blockedUser.blockedDate ?? '',
                    style: TextStyleHelper.instance.body12RegularInter,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUnblockTap,
            child: Container(
              padding: EdgeInsets.fromLTRB(14.h, 6.h, 14.h, 6.h),
              decoration: BoxDecoration(
                color: (blockedUser.isUnblocked ?? false)
                    ? Color(0xFF4F46E5)
                    : appTheme.blue_gray_100_02,
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Text(
                'Unblock',
                style: TextStyleHelper.instance.body14MediumInter.copyWith(
                    color: (blockedUser.isUnblocked ?? false)
                        ? Color(0xFFFFFFFF)
                        : appTheme.blue_gray_900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
