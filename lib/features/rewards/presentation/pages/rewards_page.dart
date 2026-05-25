import 'package:ecotrack/core/common_widgets/eco_app_bar.dart';
import 'package:ecotrack/features/home/presentation/provider/waste_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import 'package:ecotrack/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:ecotrack/features/rewards/presentation/widgets/achievement_card.dart';
import 'package:ecotrack/features/rewards/presentation/widgets/leaderboard_item.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final wasteProvider = context.read<WasteProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => context.read<RewardsProvider>().loadRewardsData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 81.h), // Space for fixed header
                      SizedBox(height: 20.h),
                      _buildPointsHero(context),
                      SizedBox(height: 32.h),
                      _buildAchievementsSection(context),
                      SizedBox(height: 32.h),
                      _buildLeaderboard(context),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: EcoAppBar(
              userProfile: profileProvider.userProfile,
              onProfileTap: () => wasteProvider.setTabIndex(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsHero(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final impactPoints = profileProvider.userProfile?.impactPoints ?? 0;
        const int targetPoints = 1500;
        final double progressPercentage = (impactPoints / targetPoints).clamp(0.0, 1.0);
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(24.w),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primarySecondary],
            ),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('TOTAL IMPACT POINTS',
                style: TextStyle(fontSize: 12.sp, color: AppColors.white.withValues(alpha: 0.8), letterSpacing: 1.2.w, fontWeight: FontWeight.w800, fontFamily: 'Manrope')),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('$impactPoints', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w800, color: AppColors.white, fontFamily: 'Plus Jakarta Sans')),
                  SizedBox(width: 8.w),
                  Text('pts', style: TextStyle(fontSize: 20.sp, color: AppColors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans')),
                ],
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Tree Planted Reward',
                      style: TextStyle(fontSize: 16.sp, color: AppColors.white, fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('${(progressPercentage * 100).toInt()}%', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.white, fontFamily: 'Plus Jakarta Sans')),
                ],
              ),
              SizedBox(height: 12.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      Container(
                        width: totalWidth,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                      ),
                      Container(
                        width: totalWidth * progressPercentage,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.progressValue,
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
              Text('Just ${impactPoints >= targetPoints ? 0 : targetPoints - impactPoints} more points to plant your 5th tree!',
                style: TextStyle(fontSize: 12.sp, color: AppColors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w800, fontFamily: 'Manrope')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Achievements', 
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontFamily: 'Plus Jakarta Sans'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text('View All', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.primarySecondary, fontFamily: 'Manrope')),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Consumer<RewardsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: provider.achievements.length,
                itemBuilder: (context, index) {
                  return AchievementCard(achievement: provider.achievements[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Consumer2<RewardsProvider, ProfileProvider>(
      builder: (context, rewardsProvider, profileProvider, _) {
        if (rewardsProvider.isLoading) {
          return const SizedBox.shrink();
        }

        final userProfile = profileProvider.userProfile;
        final impactPoints = userProfile?.impactPoints ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text('Top Eco-Warriors', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontFamily: 'Plus Jakarta Sans')),
            ),
            SizedBox(height: 20.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewardsProvider.leaderboard.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return LeaderboardItem(entry: rewardsProvider.leaderboard[index]);
              },
            ),
            SizedBox(height: 24.h),
            LeaderboardItem(
              entry: LeaderboardEntry(
                rank: 12,
                name: userProfile?.displayName ?? 'You',
                tier: userProfile?.title.toUpperCase() ?? 'RISING STAR',
                points: impactPoints,
                isYou: true,
              ),
              userPhoto: userProfile?.profilePhoto,
              userName: userProfile?.displayName,
              userTitle: userProfile?.title,
            ),
          ],
        );
      },
    );
  }
}
