import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';
import 'package:ecotrack/features/rewards/domain/repository/rewards_repository.dart';

class GetAchievementsUseCase {
  final RewardsRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<List<Achievement>> execute() {
    return repository.getAchievements();
  }
}
