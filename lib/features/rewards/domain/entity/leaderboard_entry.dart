class LeaderboardEntry {
  final int rank;
  final String name;
  final String tier;
  final int points;
  final String? profilePhoto;
  final bool isYou;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.tier,
    required this.points,
    this.profilePhoto,
    this.isYou = false,
  });
}
