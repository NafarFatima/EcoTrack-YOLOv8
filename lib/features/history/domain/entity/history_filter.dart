enum HistorySortBy { date, points, weight }

class HistoryFilter {
  final String? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final HistorySortBy sortBy;
  final bool ascending;

  HistoryFilter({
    this.categoryId,
    this.startDate,
    this.endDate,
    this.sortBy = HistorySortBy.date,
    this.ascending = false,
  });

  HistoryFilter copyWith({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    HistorySortBy? sortBy,
    bool? ascending,
  }) {
    return HistoryFilter(
      categoryId: categoryId ?? this.categoryId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}
