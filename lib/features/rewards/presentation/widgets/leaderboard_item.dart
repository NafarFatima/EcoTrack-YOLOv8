import 'package:ecotrack/core/common_widgets/eco_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final String? userPhoto;
  final String? userName;
  final String? userTitle;

  const LeaderboardItem({
    super.key,
    required this.entry,
    this.userPhoto,
    this.userName,
    this.userTitle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSvg = entry.profilePhoto?.endsWith('.svg') ?? false;
    final String displayName = entry.isYou ? (userName ?? entry.name) : entry.name;
    final String displayTier = entry.isYou ? (userTitle?.toUpperCase() ?? entry.tier) : entry.tier;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: entry.isYou ? AppColors.cardBg : AppColors.cardBg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
        border: entry.isYou ? const Border(left: BorderSide(color: AppColors.primary, width: 4)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28.w,
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _buildAvatar(isSvg),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 2.h),
                Text(
                  displayTier,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: entry.isYou ? AppColors.primarySecondary : AppColors.textMuted,
                    letterSpacing: 0.5.w,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${entry.points}',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontFamily: 'Plus Jakarta Sans'),
                ),
                TextSpan(
                  text: ' pts',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textMuted, fontFamily: 'Plus Jakarta Sans'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isSvg) {
    if (entry.isYou) {
      return EcoProfilePhoto(
        photoUrl: userPhoto,
        size: 44,
      );
    }

    if (entry.profilePhoto != null && entry.profilePhoto!.isNotEmpty) {
      if (isSvg) {
        return SizedBox(
          width: 44.r,
          height: 44.r,
          child: SvgPicture.asset(entry.profilePhoto!),
        );
      }

      return CircleAvatar(
        radius: 22.r,
        backgroundImage: AssetImage(entry.profilePhoto!),
      );
    }

    // Default fallback avatar
    return const EcoProfilePhoto(
      photoUrl: null,
      size: 44,
    );
  }
}
