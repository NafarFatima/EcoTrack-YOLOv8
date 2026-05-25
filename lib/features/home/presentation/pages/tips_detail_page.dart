import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';

class TipsDetailPage extends StatelessWidget {
  const TipsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340.h,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 18.r),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.photo4b, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Text(
                      'GREEN LIVING',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w800,
                        fontSize: 12.sp,
                        letterSpacing: 0.6.w,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '5 Small Changes to Reduce Plastic in Your Kitchen',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 32.sp,
                      height: 1.1,
                      letterSpacing: -0.8.w,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.photo8a),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'By Julian Thorne',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(Icons.access_time, size: 16.r, color: AppColors.textMuted),
                      SizedBox(width: 4.w),
                      Text(
                        '4 min read',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildSection('1. Swap to Glass Containers', 'Plastic containers can leach chemicals into your food. Glass is safer, lasts longer, and is 100% recyclable. Start by replacing your most-used sizes.'),
                  _buildSection('2. Use Beeswax Wraps', 'Ditch the cling film! Beeswax wraps are a natural, compostable alternative for covering leftovers and wrapping sandwiches.'),
                  _buildSection('3. Buy in Bulk', 'Reduce single-use packaging by bringing your own jars to bulk stores for grains, nuts, and spices. It\'s often cheaper too!'),
                  _buildSection('4. Natural Cleaning Tools', 'Swap plastic sponges for wooden brushes or loofahs that can be composted at the end of their life.'),
                  _buildSection('5. Compost Scraps', 'Organic waste in landfills produces methane. Start a small countertop compost bin for vegetable peels and coffee grounds.'),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 20.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

