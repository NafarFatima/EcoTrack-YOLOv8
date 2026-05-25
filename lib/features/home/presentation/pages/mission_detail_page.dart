import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import '../../domain/entity/eco_mission.dart';
import '../provider/mission_provider.dart';

class MissionDetailPage extends StatelessWidget {
  final EcoMission mission;

  const MissionDetailPage({super.key, required this.mission});

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
          'Mission Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  color: mission.isCompleted ? AppColors.primary : AppColors.cardBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    mission.isCompleted ? AppAssets.rewardIcon : (mission.iconPath.isEmpty ? AppAssets.recyclingIcon : mission.iconPath),
                    width: 60.r,
                    colorFilter: ColorFilter.mode(
                      mission.isCompleted ? Colors.white : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              mission.title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${mission.points} POINTS',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                if (mission.isCompleted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 32.h),
            Text(
              'About this mission',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              mission.description,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.6,
                color: AppColors.textSecondary,
                fontFamily: 'Manrope',
              ),
            ),
            SizedBox(height: 48.h),
            if (!mission.isCompleted)
              SizedBox(
                width: double.infinity,
                height: 64.h,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await context.read<MissionProvider>().completeMission(mission.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mission completed! Points added.')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Complete Mission',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
