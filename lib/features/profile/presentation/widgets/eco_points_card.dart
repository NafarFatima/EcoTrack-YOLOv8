import 'package:ecotrack/features/rewards/presentation/pages/rewards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';

class EcoPointsCard extends StatelessWidget {
  final int points;

  const EcoPointsCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RewardsPage())),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.primarySecondary,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.rewardIcon,
                width: 24.w,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              '$points',
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white,
              ),
            ),
            Text(
              'ECO POINTS',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 1.0.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
