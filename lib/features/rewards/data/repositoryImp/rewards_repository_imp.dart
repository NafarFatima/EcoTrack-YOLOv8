import 'package:ecotrack/features/rewards/data/services/rewards_service.dart';
import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';
import 'package:ecotrack/features/rewards/domain/repository/rewards_repository.dart';

class RewardsRepositoryImp implements RewardsRepository {
  final RewardsService service;

  RewardsRepositoryImp(this.service);

  @override
  Future<List<Achievement>> getAchievements() {
    return service.getAchievements();
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard() {
    return service.getLeaderboard();
  }
}
