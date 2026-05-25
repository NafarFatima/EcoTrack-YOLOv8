import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
              'Your Privacy Matters',
              style: TextStyle(
                fontSize: 24.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Last Updated: June 2024',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 24.h),
            _buildPolicySection(
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, log your waste, and interact with our community features. This includes your name, email, and recycling history.',
            ),
            _buildPolicySection(
              '2. How We Use Your Data',
              'We use the data to track your environmental impact, provide personalized rewards, and improve our services. We do not sell your personal data to third parties.',
            ),
            _buildPolicySection(
              '3. Data Security',
              'We implement industry-standard security measures to protect your information. However, no method of transmission over the internet is 100% secure.',
            ),
            _buildPolicySection(
              '4. Your Choices',
              'You can access, update, or delete your personal information at any time through the app settings or by contacting our support team.',
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.security_rounded, color: AppColors.primary, size: 32.r),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'EcoTrack is committed to ensuring that your privacy is protected.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
              height: 1.6,
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }
}
