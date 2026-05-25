import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & FAQ',
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
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Find answers to common questions about EcoTrack and how to make the most of your eco-journey.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            _buildFaqItem(
              'How are impact points calculated?',
              'Points are calculated based on the weight and type of waste logged. Different materials like glass and metal have higher point values per kilogram due to their recyclability and energy savings.',
            ),
            _buildFaqItem(
              'Can I edit a logged waste entry?',
              'Currently, you can view your history in the History tab. Editing entries is a feature we\'re working on and will be available in future updates.',
            ),
            _buildFaqItem(
              'What do the different tiers mean?',
              'Tiers represent your level of commitment to sustainability. As you earn more points, you\'ll progress from Bronze to Silver and finally Gold, unlocking exclusive badges and rewards.',
            ),
            _buildFaqItem(
              'How do I redeem my rewards?',
              'You can view your available rewards in the Rewards tab. Once you have enough points, you can click on a reward to learn how to redeem it through our partner organizations.',
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  Text(
                    'Still have questions?',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Contact our support team anytime and we\'ll get back to you as soon as possible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: AppColors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      elevation: 0,
                    ),
                    child: Text('Contact Support', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          childrenPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          iconColor: AppColors.primarySecondary,
          collapsedIconColor: AppColors.textMuted,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                height: 1.5,
                fontFamily: 'Manrope',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

