import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.r),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.historyIcon,
              width: 64.w,
              colorFilter: ColorFilter.mode(
                AppColors.primary.withValues(alpha: 0.2),
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No history yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Text(
              'Your recycling activities will appear here once you start logging them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontFamily: 'Manrope',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
