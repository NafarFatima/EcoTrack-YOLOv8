import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: achievement.bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: achievement.isLocked ? AppColors.white : achievement.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              achievement.iconPath,
              colorFilter: ColorFilter.mode(achievement.color, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
              color: achievement.isLocked ? AppColors.textMuted : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
