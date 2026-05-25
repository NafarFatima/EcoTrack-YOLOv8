import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/splash/presentation/provider/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/features/authentication/presentation/pages/login_page.dart';


class OnboardingButtons extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onContinue;

  const OnboardingButtons({
    super.key,
    required this.isLastPage,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Continue Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySecondary,
              foregroundColor: AppColors.white,
              minimumSize: Size(double.infinity, 64.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastPage ? 'Get Started' : 'Continue',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.arrow_forward, size: 20.r),
              ],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Already have an account Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GestureDetector(
            onTap: () async {
              await context.read<SplashProvider>().completeOnboarding();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 64.h,
              decoration: BoxDecoration(
                color: AppColors.cardBg.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Center(
                child: Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Manrope',
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
