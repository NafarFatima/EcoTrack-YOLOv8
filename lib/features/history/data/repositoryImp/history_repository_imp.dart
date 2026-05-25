import 'package:flutter/foundation.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import 'package:ecotrack/features/home/data/model/waste_model.dart';
import '../../domain/repository/history_repository.dart';
import '../services/history_service.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';

class HistoryRepositoryImp implements HistoryRepository {
  final HistoryService historyService;

  HistoryRepositoryImp(this.historyService);

  Future<List<WasteItem>> _getCategoriesCached() async {
    try {
      final categoryDocs = await historyService.getCategories();
      return categoryDocs.map((doc) => WasteItemModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("HistoryRepo: Error fetching categories: $e");
      return [];
    }
  }

  @override
  Stream<List<LoggedWaste>> watchWasteHistory(String userId) {
    debugPrint("HistoryRepo: watchWasteHistory called for UID: $userId");
    
    if (userId.isEmpty) {
      debugPrint("HistoryRepo: UID is empty, returning empty stream");
      return Stream.value([]);
    }

    // Combine categories and logs more robustly
    return historyService.getWasteLogs(userId).asyncMap((snapshot) async {
      debugPrint("HistoryRepo: Firestore emitted ${snapshot.docs.length} log documents");
      
      final categories = await _getCategoriesCached();
      
      final logs = snapshot.docs.map((doc) {
        try {
          return LoggedWasteModel.fromFirestore(doc, categories);
        } catch (e) {
          debugPrint("HistoryRepo: Parse error for doc ${doc.id}: $e");
          return null;
        }
      }).whereType<LoggedWaste>().toList();

      // Manual sorting to ensure order without requiring composite index
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      debugPrint("HistoryRepo: Yielding ${logs.length} logs to stream");
      return logs;
    }).handleError((error) {
      debugPrint("HistoryRepo: Stream encountered error: $error");
      return <LoggedWaste>[];
    });
  }
}
