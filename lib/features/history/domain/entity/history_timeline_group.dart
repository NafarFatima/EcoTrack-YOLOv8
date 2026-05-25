import 'package:ecotrack/core/domain/entity/logged_waste.dart';

class HistoryTimelineGroup {
  final String title; // e.g., "Today", "Yesterday", "October 2023"
  final List<LoggedWaste> items;
  final int totalPointsInGroup;

  HistoryTimelineGroup({
    required this.title,
    required this.items,
    required this.totalPointsInGroup,
  });
}
