import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';

class RewardsService {
  Future<List<Achievement>> getAchievements() async {
    // Simulate API call
    return [
      Achievement(
        id: '1',
        title: 'Nature Guardian',
        description: '10 days streak',
        iconPath: AppAssets.achievementIcon1,
        color: AppColors.achiev1,
        bgColor: AppColors.achiev1Bg,
      ),
      Achievement(
        id: '2',
        title: 'Carbon Neutral',
        description: 'Offset 50kg CO2',
        iconPath: AppAssets.achievementIcon2,
        color: AppColors.achiev2,
        bgColor: AppColors.achiev2Bg,
      ),
      Achievement(
        id: '3',
        title: 'Soil Master',
        description: 'Composted 20 items',
        iconPath: AppAssets.achievementIcon3,
        color: AppColors.achiev3,
        bgColor: AppColors.achiev3Bg,
      ),
      Achievement(
        id: '4',
        title: 'Ocean Hero',
        description: 'Locked achievement',
        iconPath: AppAssets.achievementIcon4,
        color: AppColors.achiev4,
        bgColor: AppColors.achiev4Bg,
        isLocked: true,
      ),
    ];
  }

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    // Simulate API call
    return [
      LeaderboardEntry(rank: 1, name: 'Marcus Green', tier: 'LEGENDARY', points: 3420, profilePhoto: AppAssets.photo7b),
      LeaderboardEntry(rank: 2, name: 'Elena Rivers', tier: 'PRO', points: 2890, profilePhoto: AppAssets.photo7c),
      LeaderboardEntry(rank: 3, name: 'Tai Zhang', tier: 'PRO', points: 2150, profilePhoto: AppAssets.photo7d),
    ];
  }
}
