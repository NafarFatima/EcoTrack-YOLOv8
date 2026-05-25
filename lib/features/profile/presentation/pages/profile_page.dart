import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/eco_points_card.dart';
import '../widgets/setting_item.dart';
import 'package:ecotrack/features/push_notification/presentation/pages/notifications_page.dart';
import 'help_faq_page.dart';
import 'package:ecotrack/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ecotrack/features/splash/presentation/pages/splash_page.dart';

import 'privacy_policy_page.dart';
import 'general_settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // No need to manually call loadProfile as ProfileProvider handles it via authStateChanges
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.userProfile == null) {
                    return SizedBox(
                      height: 200.h,
                      child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }
                  
                  if (provider.errorMessage != null && provider.userProfile == null) {
                    return Container(
                      padding: EdgeInsets.all(24.r),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
                            SizedBox(height: 12.h),
                            Text(provider.errorMessage!, style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    );
                  }

                  final profile = provider.userProfile;
                  if (profile == null) return const SizedBox.shrink();

                  return ProfileCard(profile: profile);
                },
              ),
              SizedBox(height: 16.h),
              Consumer<ProfileProvider>(
                builder: (context, provider, _) => EcoPointsCard(
                  points: provider.userProfile?.impactPoints ?? 0,
                ),
              ),
              SizedBox(height: 32.h),
              _buildSettingsSection(context),
              SizedBox(height: 32.h),
              _buildLogout(context),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 24.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 18.w),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
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
                      width: 15.w,
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
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SettingItem(
          iconPath: AppAssets.securityIcon,
          title: 'General Settings',
          subtitle: 'Manage your account and app',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralSettingsPage())),
        ),
        SettingItem(
          iconPath: AppAssets.notificationSettingIcon,
          title: 'Notifications',
          subtitle: 'Manage alerts and news',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
        ),
        SettingItem(
          iconPath: AppAssets.helpIcon,
          title: 'Help / FAQ',
          subtitle: 'Common questions and support',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpFaqPage())),
        ),
        SettingItem(
          iconPath: AppAssets.securityIcon,
          title: 'Privacy Policy',
          subtitle: 'Data usage and security',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage())),
        ),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          final authNotifier = context.read<AuthNotifier>();
          final navigator = Navigator.of(context);
          await authNotifier.signOut();
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
        },
        icon: SvgPicture.asset(AppAssets.logoutIcon, width: 18.w, colorFilter: const ColorFilter.mode(AppColors.danger, BlendMode.srcIn)),
        label: Text(
          'Logout',
          style: TextStyle(
            color: AppColors.danger,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
