import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/features/home/presentation/pages/home_page.dart';
import 'package:ecotrack/features/add/presentation/pages/add_page.dart';
import 'package:ecotrack/features/history/presentation/pages/history_page.dart';
import 'package:ecotrack/features/rewards/presentation/pages/rewards_page.dart';
import 'package:ecotrack/features/profile/presentation/pages/profile_page.dart';
import 'package:provider/provider.dart';
import '../provider/waste_provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<Widget> _screens = const [
    HomeScreen(),
    AddPage(),
    HistoryPage(),
    RewardsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final wasteProvider = context.watch<WasteProvider>();

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[wasteProvider.selectedTabIndex],
          if (wasteProvider.errorMessage != null)
            _buildErrorOverlay(context, wasteProvider),
        ],
      ),
      bottomNavigationBar: Container(
        height: 84.h + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder,
              width: 1.r,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 40.r,
              offset: Offset(0, -10.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24.r, sigmaY: 24.r),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16.h,
                left: 16.w,
                right: 16.w,
                bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(context, 0, 'Home', AppAssets.homeIcon),
                  _buildNavItem(context, 1, 'Add', AppAssets.addIcon),
                  _buildNavItem(context, 2, 'History', AppAssets.historyIcon),
                  _buildNavItem(context, 3, 'Rewards', AppAssets.rewardIcon),
                  _buildNavItem(context, 4, 'Profile', AppAssets.profileIcon),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String label, String iconPath) {
    final wasteProvider = context.read<WasteProvider>();
    bool isSelected = wasteProvider.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => wasteProvider.setTabIndex(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 55.h,
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: isSelected ? 16.r : 20.r,
                height: isSelected ? 18.r : 20.r,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.textMuted,
                  BlendMode.srcIn,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: 0.5.w,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(BuildContext context, WasteProvider provider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.h,
      left: 20.w,
      right: 20.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 24.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 20.r),
                onPressed: () {
                  // In a real app, you'd add a clearError method to WasteProvider
                  // For now, we can just trigger a rebuild or add it to WasteProvider
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
