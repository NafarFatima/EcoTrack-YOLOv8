import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/splash/presentation/provider/splash_provider.dart';
import 'package:ecotrack/features/authentication/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';


class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/photo2a.png', width: 24.w, height: 24.h),
              SizedBox(width: 8.w),
              Text(
                'EcoTrack',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                  color: AppColors.primary,
                  height: 1.33,
                  letterSpacing: -1.2.w,
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, 
              minimumSize: Size.zero, 
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () async {
              await context.read<SplashProvider>().completeOnboarding();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                fontFamily: 'Manrope',
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
