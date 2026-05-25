import '../repository/mission_repository.dart';

class CompleteMissionUseCase {
  final MissionRepository repository;

  CompleteMissionUseCase(this.repository);

  Future<void> execute(String userId, String missionId) async {
    return await repository.completeMission(userId, missionId);
  }
}
