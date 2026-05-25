import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';

class OnboardingItemWidget extends StatelessWidget {
  final OnboardingContent item;

  const OnboardingItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.h),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 340.h,
              ),
            ),
            SizedBox(height: 25.h),
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1,
                    fontFamily: 'Plus Jakarta Sans',
                    letterSpacing: -1.0.w,
                  ),
                  children: [
                    TextSpan(text: '${item.title}\n'),
                    TextSpan(
                      text: item.titleHighlighted,
                      style: const TextStyle(
                        color: AppColors.primarySecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // Description Text
            Text(
              item.description,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
