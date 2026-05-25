import 'package:ecotrack/features/home/presentation/pages/missions_page.dart';
import 'package:ecotrack/core/common_widgets/eco_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/domain/entity/user_profile.dart';
import '../pages/edit_profile_page.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              EcoProfilePhoto(
                photoUrl: profile.profilePhoto,
                size: 100,
                borderWith: 2,
                borderColor: AppColors.primary,
                iconSize: 50,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit, size: 16.r, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.displayName,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.title,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())),
                  child: _buildActionButton('Edit Profile', AppColors.primary, AppColors.white),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MissionsPage())),
                  child: _buildStatusBadge(context, 'Level ${profile.level}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bg, Color text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 14.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, size: 14.r, color: AppColors.primary),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
