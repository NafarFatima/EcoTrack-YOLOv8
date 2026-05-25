import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import 'missions_page.dart';
import 'mission_detail_page.dart';
import 'tips_detail_page.dart';
import '../provider/waste_provider.dart';
import '../provider/mission_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_app_bar.dart';
import 'package:ecotrack/core/services/detector_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 110.h), // Space for fixed header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18),
                    child: Consumer2<WasteProvider, MissionProvider>(
                      builder: (context, wasteProvider, missionProvider, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreetingHeader(wasteProvider),
                          SizedBox(height: 24.h),
                          _buildWeeklyProgressBar(wasteProvider),
                          SizedBox(height: 24.h),
                          _buildQuickActions(context, wasteProvider),
                          SizedBox(height: 24.h),
                          _buildStatCards(context),
                          SizedBox(height: 32.h),
                          _buildDailyMissions(context, missionProvider),
                          SizedBox(height: 32.h),
                          _buildWeeklyWisdom(context),
                          SizedBox(height: 140.h), // Extra space for bottom nav
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Consumer2<WasteProvider, ProfileProvider>(
              builder: (context, wasteProvider, profileProvider, _) {
                return EcoAppBar(
                  userProfile: profileProvider.userProfile,
                  onProfileTap: () => wasteProvider.setTabIndex(4),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildGreetingHeader(WasteProvider wasteProvider) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final name = profileProvider.userProfile?.displayName ?? "User";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${name.split(' ')[0]}!',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                fontSize: 32.sp,
                height: 1.1,
                letterSpacing: -0.9.w,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ready to make a difference today?',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyProgressBar(WasteProvider provider) {
    // Calculate progress based on points or actual weight if available
    // For now, let's use points as a proxy or just some dynamic logic
    const double weeklyGoal = 15.0;
    final double currentWaste = (provider.history.where((log) => 
      log.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 7)))
    ).fold(0.0, (sum, log) => sum + log.quantity));
    
    final double progressPercentage = (currentWaste / weeklyGoal).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBorder.withValues(alpha: 0.1),
            blurRadius: 12.r,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY RECYCLING GOAL',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      fontSize: 10.sp,
                      height: 1.5,
                      letterSpacing: 1.0.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${currentWaste.toStringAsFixed(1)} kg ',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w800,
                            fontSize: 24.sp,
                            height: 1.33,
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: '/ ${weeklyGoal.toInt()} kg',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  '${(progressPercentage * 100).toInt()}% COMPLETE',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 10.sp,
                    height: 1.5,
                    letterSpacing: -0.25.w,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    width: totalWidth,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                  ),
                  Container(
                    width: totalWidth * progressPercentage,
                    height: 16.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(9999.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12.r,
                        offset: Offset.zero,
                      ),
                    ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WasteProvider wasteProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Add Item',
            AppAssets.addIcon,
            null, // Linear gradient used instead
            Colors.white,
            onTap: () {
              DetectorService.resetPresentation();
              wasteProvider.setTabIndex(1, openGallery: true);
            },
            isGradient: true,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildActionButton(
            context,
            'Log Habit',
            AppAssets.logIcon,
            AppColors.cardBg,
            AppColors.accentTeal,
            onTap: () {
              DetectorService.resetPresentation();
              wasteProvider.setTabIndex(1, openGallery: true, focusName: false);
            },
            isGradient: false,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String iconPath,
    Color? bgColor,
    Color textColor, {
    required VoidCallback onTap,
    bool isGradient = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64.h,
        decoration: BoxDecoration(
          color: isGradient ? null : bgColor,
          gradient: isGradient
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment(1.0, -0.36),
                  end: Alignment(-1.0, 0.36),
                )
              : null,
          borderRadius: BorderRadius.circular(48.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(
              iconPath,
              width: 18.w,
              height: 18.w,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.userProfile;
        final impactPoints = profile?.impactPoints ?? 0;
        final level = profile?.level ?? 1;
        final title = profile?.title ?? "Eco Warrior";

        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              // CO2 Saved Card
              Expanded(
                child: Container(
                  height: 180.h,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(color: AppColors.cardBorder, width: 1.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.co2Icon,
                            width: 20.r,
                            height: 10.r,
                            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'CO2 SAVED',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 11.sp,
                          letterSpacing: 0.5.w,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(impactPoints * 0.5).toStringAsFixed(1)} kg',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w800,
                          fontSize: 24.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Level $level',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Eco Points Card
              Expanded(
                child: Container(
                  height: 180.h,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 15.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.rewardIcon,
                            width: 20.r,
                            height: 20.r,
                            colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'ECO POINTS',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 11.sp,
                          letterSpacing: 0.5.w,
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '$impactPoints',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w800,
                          fontSize: 30.sp,
                          height: 1.0,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyMissions(BuildContext context, MissionProvider missionProvider) {
    final missions = missionProvider.missions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(48.r),
          bottomRight: Radius.circular(32.r),
          bottomLeft: Radius.circular(48.r),
        ),
        border: Border.all(color: AppColors.cardBorder, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Eco-Missions',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                  height: 1.0,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MissionsPage()),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                    height: 1.33,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          if (missionProvider.isLoading && missions.isEmpty)
            const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (missions.isEmpty)
            Text(
              "No missions available today!",
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: () {
                // Filter specifically for the 3 main missions for home: Plastic, Paper, Organic
                final displayMissions = missions.where((m) {
                  final title = m.title.toLowerCase();
                  return title.contains('plastic') || title.contains('paper') || title.contains('organic');
                }).toList();
                
                // Fallback to first 3 if specific ones aren't found
                final itemsToShow = displayMissions.isNotEmpty ? displayMissions : (missions.length > 3 ? missions.sublist(0, 3) : missions);

                return itemsToShow.map((mission) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissionDetailPage(mission: mission),
                        ),
                      ),
                      child: _buildMissionItem(
                        context,
                        mission.title,
                        mission.isCompleted
                            ? 'COMPLETED • +${mission.points} PTS'
                            : 'PENDING • ${mission.points} PTS',
                        mission.iconPath.isEmpty
                            ? AppAssets.recyclingIcon
                            : mission.iconPath,
                        mission.isCompleted,
                      ),
                    ),
                  );
                }).toList();
              }(),
            ),
        ],
      ),
    );
  }

  Widget _buildMissionItem(BuildContext context, String title, String status, String iconPath, bool isCompleted) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 72.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCompleted 
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.secondary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(48.r),
        border: isCompleted 
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.w)
            : Border.all(color: Colors.transparent, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.5),
            blurRadius: 2.r,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primary : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                isCompleted ? AppAssets.rewardIcon : iconPath,
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(
                  isCompleted ? Colors.white : AppColors.primary,
                  BlendMode.srcIn
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                    height: 1.42,
                    color: isCompleted ? AppColors.textPrimary.withValues(alpha: 0.7) : AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 10.sp,
                    height: 1.5,
                    letterSpacing: -0.25.w,
                    color: isCompleted ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 20.r,
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyWisdom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 28.h,
          child: Text(
            'Weekly Wisdom',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              height: 1.0,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TipsDetailPage())),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 288.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
                BoxShadow(
                  color: AppColors.cardBorder.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 8.h),
                  spreadRadius: -6.r,
                ),
                BoxShadow(
                  color: AppColors.cardBorder.withValues(alpha: 0.1),
                  blurRadius: 25.r,
                  offset: Offset(0, 20.h),
                  spreadRadius: -5.r,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.photo4b,
                    width: double.infinity,
                    height: 288.h,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 288.h,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(9999.r),
                            ),
                            child: Text(
                              'GREEN LIVING',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w800,
                                fontSize: 10.sp,
                                height: 1.5,
                                letterSpacing: 1.0.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '5 Small Changes to Reduce Plastic in Your Kitchen',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w800,
                            fontSize: 20.sp,
                            height: 1.25,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Start your journey to zero-waste with these simple, actionable tips that make a big…',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w800,
                              fontSize: 14.sp,
                              height: 1.42,
                              color: Colors.white.withValues(alpha: 0.8),
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
        ),
      ],
    );
  }
}
