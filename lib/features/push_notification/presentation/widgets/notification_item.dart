import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';

class NotificationItem extends StatelessWidget {
  final PushNotification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: notification.isNew ? AppColors.white : AppColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: notification.isNew ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10.r, offset: Offset(0, 4.h))] : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: notification.isNew ? AppColors.accent : AppColors.cardBg,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                notification.iconPath,
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(notification.isNew ? AppColors.primarySecondary : AppColors.textMuted, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (notification.isNew)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, left: 8.w),
                          child: Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: AppColors.primarySecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
