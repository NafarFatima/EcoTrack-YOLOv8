import 'package:ecotrack/features/rewards/domain/entity/leaderboard_entry.dart';

class LeaderboardModel extends LeaderboardEntry {
  LeaderboardModel({
    required super.rank,
    required super.name,
    required super.tier,
    required super.points,
    super.profilePhoto,
    super.isYou,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] ?? 0,
      name: json['name'] ?? '',
      tier: json['tier'] ?? '',
      points: json['points'] ?? 0,
      profilePhoto: json['profilePhoto'],
      isYou: json['isYou'] ?? false,
    );
  }
}
