import 'package:ecotrack/features/home/presentation/provider/waste_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EcoStatsChart extends StatelessWidget {
  const EcoStatsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WasteProvider>(
      builder: (context, provider, child) {
        final stats = _getWeeklyStats(provider.history);
        final maxVal = stats.values.isEmpty ? 1.0 : stats.values.reduce((a, b) => a > b ? a : b);
        final normalizedValues = stats.values.map((v) => maxVal == 0 ? 0.0 : v / maxVal).toList();
        final days = stats.keys.toList();

        return Container(
          height: 180.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IMPACT OVERVIEW',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'THIS WEEK',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primarySecondary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _BarChartPainter(values: normalizedValues),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days.map((day) => 
                  SizedBox(
                    width: 32.w,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, double> _getWeeklyStats(dynamic history) {
    final Map<String, double> stats = {};
    final now = DateTime.now();
    
    // Initialize last 7 days with 0
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      stats[DateFormat('yyyy-MM-dd').format(date)] = 0.0;
    }

    // Sum quantities per day
    for (var log in history) {
      final dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      if (stats.containsKey(dateKey)) {
        stats[dateKey] = (stats[dateKey] ?? 0.0) + log.quantity;
      }
    }

    // Convert keys to day initials for display
    final Map<String, double> result = {};
    stats.forEach((key, value) {
      final date = DateFormat('yyyy-MM-dd').parse(key);
      result[DateFormat('E').format(date)[0]] = value;
    });

    return result;
  }
}

class _BarChartPainter extends StatelessWidget {
  final List<double> values;
  const _BarChartPainter({required this.values});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: values.map((val) => Container(
            width: 32.w,
            height: (constraints.maxHeight * val).clamp(4.h, constraints.maxHeight),
            decoration: BoxDecoration(
              color: val > 0.8 ? AppColors.primary : AppColors.primarySecondary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8.w),
            ),
          )).toList(),
        );
      },
    );
  }
}

