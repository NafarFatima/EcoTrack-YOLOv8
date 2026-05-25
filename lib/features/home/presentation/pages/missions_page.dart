import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import '../provider/mission_provider.dart';
import 'mission_detail_page.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daily Eco-Missions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MissionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.missions.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (provider.missions.isEmpty) {
            return Center(
              child: Text(
                'No missions available today!',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(24.w),
            itemCount: provider.missions.length,
            itemBuilder: (context, index) {
              final mission = provider.missions[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MissionDetailPage(mission: mission),
                    ),
                  ),
                  child: _buildMissionItem(
                    context,
                    mission.title,
                    mission.isCompleted
                        ? 'COMPLETED • +${mission.points} PTS'
                        : 'PENDING • ${mission.points} PTS',
                    mission.iconPath.isEmpty ? AppAssets.recyclingIcon : mission.iconPath,
                    mission.isCompleted,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMissionItem(BuildContext context, String title, String status, String iconPath, bool isCompleted) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 80.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCompleted 
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.cardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: isCompleted 
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.w)
            : Border.all(color: AppColors.cardBorder, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBorder.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primary : AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                isCompleted ? AppAssets.rewardIcon : iconPath,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(
                  isCompleted ? Colors.white : AppColors.primary, 
                  BlendMode.srcIn
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    color: isCompleted ? AppColors.textPrimary.withValues(alpha: 0.6) : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    letterSpacing: 0.5.w,
                    color: isCompleted ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 24.r,
            )
          else
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 16.r,
            ),
        ],
      ),
    );
  }
}
