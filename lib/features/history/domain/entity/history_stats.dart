class HistoryStats {
  final int totalItemsRecycled;
  final int totalPointsEarned;
  final double totalWeight;
  final Map<String, int> categoryBreakdown;

  HistoryStats({
    required this.totalItemsRecycled,
    required this.totalPointsEarned,
    required this.totalWeight,
    required this.categoryBreakdown,
  });

  factory HistoryStats.empty() {
    return HistoryStats(
      totalItemsRecycled: 0,
      totalPointsEarned: 0,
      totalWeight: 0.0,
      categoryBreakdown: {},
    );
  }
}
