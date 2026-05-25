import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';

abstract class RewardsRepository {
  Future<List<Achievement>> getAchievements();
  Future<List<LeaderboardEntry>> getLeaderboard();
}
