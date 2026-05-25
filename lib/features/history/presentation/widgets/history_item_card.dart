import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';

class HistoryItemCard extends StatelessWidget {
  final LoggedWaste log;

  const HistoryItemCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              _getIconForCategory(log.category.title),
              color: Colors.white,
              size: 20.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.itemName ?? log.category.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Plus Jakarta Sans',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${log.quantity}kg collected • ${log.location}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${log.pointsEarned} XP',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.primary,
            ),
          ),
        ],
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
}
