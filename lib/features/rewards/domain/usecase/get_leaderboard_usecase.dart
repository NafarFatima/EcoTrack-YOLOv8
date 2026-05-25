import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';
import 'package:ecotrack/features/rewards/domain/repository/rewards_repository.dart';

class GetLeaderboardUseCase {
  final RewardsRepository repository;

  GetLeaderboardUseCase(this.repository);

  Future<List<LeaderboardEntry>> execute() {
    return repository.getLeaderboard();
  }
}
