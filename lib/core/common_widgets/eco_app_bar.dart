import 'package:ecotrack/core/common_widgets/eco_profile_photo.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/domain/entity/user_profile.dart';
import 'package:ecotrack/features/push_notification/presentation/pages/notifications_page.dart';

class EcoAppBar extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback onProfileTap;

  const EcoAppBar({
    super.key,
    required this.userProfile,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.r, sigmaY: 12.r),
        child: Container(
          width: double.infinity,
          height: 81.h + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16.h,
            bottom: 16.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: AppColors.cardBorder,
                width: 1.w,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onProfileTap,
                    child: EcoProfilePhoto(
                      photoUrl: userProfile?.profilePhoto,
                      size: 40,
                      borderWith: 2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'EcoTrack',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 20.sp,
                      height: 1.4,
                      letterSpacing: -0.5.w,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Welcome to EcoTrack! 🌿'),
                      duration: Duration(seconds: 2),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsPage()),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.bellIcon,
                          width: 16.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
