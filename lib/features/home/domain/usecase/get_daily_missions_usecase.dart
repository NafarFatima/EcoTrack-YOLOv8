import '../entity/eco_mission.dart';
import '../repository/mission_repository.dart';

class GetDailyMissionsUseCase {
  final MissionRepository repository;

  GetDailyMissionsUseCase(this.repository);

  Stream<List<EcoMission>> execute(String userId) {
    return repository.getDailyMissions(userId);
  }
}
