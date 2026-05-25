import 'package:ecotrack/core/common_widgets/eco_app_bar.dart';
import 'package:ecotrack/features/home/presentation/provider/waste_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import '../provider/history_provider.dart';
import '../widgets/history_item_card.dart';
import '../widgets/history_empty_state.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final history = provider.history;
    final isLoading = provider.isLoading;
    final errorMessage = provider.errorMessage;

    final wasteProvider = context.read<WasteProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 81.h), // Space for fixed header
                  _buildSearchBar(provider),
                  if (provider.selectedTab == HistoryTab.history && provider.selectedCategoryId != null)
                    _buildCategoryFilterHeader(provider),
                  _buildTabs(provider),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => provider.fetchHistory(),
                      color: AppColors.primary,
                      child: errorMessage != null
                          ? _buildErrorState(errorMessage)
                          : isLoading && history.isEmpty && provider.selectedTab == HistoryTab.history
                              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                              : provider.selectedTab == HistoryTab.history 
                                  ? (history.isEmpty ? const SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child: HistoryEmptyState()) : _buildHistoryContent(provider))
                                  : _buildCategoriesGrid(provider),
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
            child: EcoAppBar(
              userProfile: profileProvider.userProfile,
              onProfileTap: () => wasteProvider.setTabIndex(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(HistoryProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: provider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search activities...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 24.r),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(HistoryProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabItem(provider, HistoryTab.history, 'History')),
            Expanded(child: _buildTabItem(provider, HistoryTab.categories, 'Categories')),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(HistoryProvider provider, HistoryTab tab, String label) {
    final isSelected = provider.selectedTab == tab;
    return GestureDetector(
      onTap: () => provider.setTab(tab),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.1)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontFamily: 'Manrope',
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterHeader(HistoryProvider provider) {
    final category = provider.categories.firstWhere((c) => c.id == provider.selectedCategoryId);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(_getIconForCategory(category.title), color: AppColors.primary, size: 20.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Showing ${category.title} logs',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            GestureDetector(
              onTap: provider.clearCategoryFilter,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: AppColors.primary, size: 16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent(HistoryProvider provider) {
    return Column(
      children: [
        if (provider.selectedCategoryId == null) _buildSummaryCard(provider),
        Expanded(child: _buildHistoryList(provider)),
      ],
    );
  }

  Widget _buildSummaryCard(HistoryProvider provider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF2DDA93)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Points Summary',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Manrope',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${provider.getTotalPoints()} Total Points',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.categories.where((c) => provider.getPointsForCategory(c.id) > 0).map((category) {
                final categoryPoints = provider.getPointsForCategory(category.id);
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(_getIconForCategory(category.title), color: Colors.white, size: 14.r),
                      SizedBox(width: 6.w),
                      Text(
                        '${category.title}: $categoryPoints',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(HistoryProvider provider) {
    final groupedData = provider.getGroupedHistory();
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final date = groupedData.keys.elementAt(index);
        final logs = groupedData[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 1.w,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
            ...logs.map((log) => HistoryItemCard(log: log)),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesGrid(HistoryProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    'Categories',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  Text(
                    'Proper waste identification',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${provider.categories.length} GROUPS',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.8,
            ),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return _buildCategoryCard(context, provider, category);
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, HistoryProvider provider, WasteItem category) {
    final points = provider.getPointsForCategory(category.id);
    return GestureDetector(
      onTap: () => provider.filterByCategory(category.id),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24.r),
          border: provider.selectedCategoryId == category.id 
              ? Border.all(color: AppColors.primary, width: 2.w)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                     _getIconForCategory(category.title),
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                ),
                if (points > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '+$points pts',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              category.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              category.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontFamily: 'Manrope',
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String title) {
    final t = title.toLowerCase();
    if (t.contains('plastic')) return Icons.local_drink_rounded;
    if (t.contains('paper')) return Icons.menu_book_rounded;
    if (t.contains('glass')) return Icons.wine_bar_rounded;
    if (t.contains('metal')) return Icons.precision_manufacturing_rounded;
    if (t.contains('organic')) return Icons.eco_rounded;
    if (t.contains('electronic')) return Icons.devices_other_rounded;
    return Icons.recycling_rounded;
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
