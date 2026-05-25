import 'package:flutter/material.dart';
import 'package:ecotrack/features/rewards/domain/entity/achievement.dart';
import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';
import 'package:ecotrack/features/rewards/domain/usecase/get_achievements_usecase.dart';
import 'package:ecotrack/features/rewards/domain/usecase/get_leaderboard_usecase.dart';

class RewardsProvider extends ChangeNotifier {
  final GetAchievementsUseCase getAchievementsUseCase;
  final GetLeaderboardUseCase getLeaderboardUseCase;

  List<Achievement> _achievements = [];
  List<Achievement> get achievements => _achievements;

  List<LeaderboardEntry> _leaderboard = [];
  List<LeaderboardEntry> get leaderboard => _leaderboard;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RewardsProvider({
    required this.getAchievementsUseCase,
    required this.getLeaderboardUseCase,
  });

  Future<void> loadRewardsData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        getAchievementsUseCase.execute(),
        getLeaderboardUseCase.execute(),
      ]);

      _achievements = results[0] as List<Achievement>;
      _leaderboard = results[1] as List<LeaderboardEntry>;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
