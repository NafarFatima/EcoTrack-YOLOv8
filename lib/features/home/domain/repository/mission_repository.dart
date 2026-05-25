import '../entity/eco_mission.dart';

abstract class MissionRepository {
  Stream<List<EcoMission>> getDailyMissions(String userId);
  Future<void> completeMission(String userId, String missionId);
}
