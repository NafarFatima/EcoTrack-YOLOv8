import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import 'package:ecotrack/core/services/detector_service.dart';
import '../../domain/entity/waste_category.dart';
import '../../domain/usecase/get_add_categories_usecase.dart';
import '../../domain/usecase/add_log_waste_usecase.dart';
import 'package:ecotrack/features/home/domain/usecase/complete_mission_usecase.dart';
import 'package:ecotrack/features/home/domain/entity/eco_mission.dart';

class AddProvider extends ChangeNotifier {
  final GetAddCategoriesUseCase getCategoriesUseCase;
  final AddLogWasteUseCase logWasteUseCase;
  final CompleteMissionUseCase completeMissionUseCase;
  final DetectorService _detector = DetectorService();

  List<WasteCategory> _categories = [];
  List<WasteCategory> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AddProvider({
    required this.getCategoriesUseCase,
    required this.logWasteUseCase,
    required this.completeMissionUseCase,
  }) {
    refreshCategories();
    _detector.init();
  }

  Future<void> refreshCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await getCategoriesUseCase.execute();
    } catch (e) {
      _errorMessage = "Failed to load categories.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> detectCategory(File image) async {
    // Ensure categories are loaded before detecting
    if (_categories.isEmpty) {
      await refreshCategories();
    }
    
    final prediction = await _detector.predict(image);
    if (prediction != null && _categories.isNotEmpty) {
      final String label = (prediction['label'] ?? '').toString().toLowerCase();
      final double confidence = prediction['confidence'] ?? 0.0;
      final int? predictedIndex = prediction['index'];
      
      debugPrint("AI RAW: Label=$label, Index=$predictedIndex, Conf=$confidence");
      
      // Ultra-lenient for demo: 10% confidence is enough
      if (confidence < 0.10) return {'index': null, 'label': label, 'confidence': confidence, 'lowConfidence': true};

      int? foundIndex;

      // Match AI label to Firestore Category Title
      final String normalizedLabel = label.trim().toLowerCase();
      
      for (int i = 0; i < _categories.length; i++) {
        final String catTitle = _categories[i].title.toLowerCase();
        
        // Match logic: 'glass' matches 'Glass', 'paper' matches 'Paper'
        if (catTitle == normalizedLabel || 
            catTitle.contains(normalizedLabel) || 
            normalizedLabel.contains(catTitle)) {
          foundIndex = i;
          break;
        }

        // Common Synonyms
        if (normalizedLabel == 'glass' && catTitle.contains('glass')) { foundIndex = i; break; }
        if (normalizedLabel == 'paper' && catTitle.contains('paper')) { foundIndex = i; break; }
        if (normalizedLabel == 'metal' && (catTitle.contains('metal') || catTitle.contains('can'))) { foundIndex = i; break; }
        if (normalizedLabel == 'plastic' && catTitle.contains('plastic')) { foundIndex = i; break; }
      }

      return {
        'index': foundIndex, // This is now the correct index in the UI list
        'label': label,
        'confidence': confidence,
      };
    }
    return null;
  }

  int _lastPointsEarned = 0;
  int get lastPointsEarned => _lastPointsEarned;

  Future<void> logWaste({
    required WasteCategory category,
    required double quantity,
    required String location,
    String? itemName,
    String? notes,
    File? imageFile,
    List<EcoMission> availableMissions = const [],
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? imageUrl;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        imageUrl = base64Encode(bytes);
      }

      final wastePoints = (quantity * category.pointsPerKg).round();
      debugPrint("AddProvider: Base waste points: $wastePoints for ${category.title}");
      _lastPointsEarned = wastePoints;
      
      final log = LoggedWaste(
        id: '',
        category: WasteItem(
          id: category.id,
          title: category.title,
          description: category.description,
          iconPath: category.iconPath,
          colorValue: category.colorValue,
          pointsPerKg: category.pointsPerKg,
        ),
        quantity: quantity,
        location: location,
        timestamp: DateTime.now(),
        pointsEarned: wastePoints,
        itemName: itemName,
        notes: notes,
        imageUrl: imageUrl,
      );

      await logWasteUseCase.execute(user.uid, log);

      // Automatic Mission Completion Logic
      final missionPoints = await _checkAndCompleteMission(user.uid, category.title, availableMissions);
      _lastPointsEarned += missionPoints;
      
      // Update the user's total points in the profile if needed
      // Note: The repository already increments points for the waste log and mission completion separately in Firestore.
      // This local calculation is for the success toast.

      debugPrint("AddProvider: Mission points: $missionPoints. Total points for this action: $_lastPointsEarned");
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<int> _checkAndCompleteMission(String userId, String categoryTitle, List<EcoMission> missions) async {
    if (missions.isEmpty) return 0;

    final String normalizedCategory = categoryTitle.toLowerCase();
    int totalMissionPoints = 0;
    
    // Find missions that match the category and are NOT completed
    for (final m in missions) {
      if (m.isCompleted) continue;

      final title = m.title.toLowerCase();
      bool matches = false;
      
      // Keywords matching sensitivity
      if (normalizedCategory.contains('plastic') && title.contains('plastic')) {
        matches = true;
      } else if (normalizedCategory.contains('paper') && title.contains('paper')) {
        matches = true;
      } else if (normalizedCategory.contains('organic') && (title.contains('organic') || title.contains('explorer'))) {
        matches = true;
      } else if (normalizedCategory.contains('metal') && title.contains('metal')) {
        matches = true;
      } else if (normalizedCategory.contains('glass') && title.contains('glass')) {
        matches = true;
      } else if (normalizedCategory.contains('electronic') || normalizedCategory.contains('e-waste')) {
        if (title.contains('tech') || title.contains('electronic') || title.contains('e-waste')) {
          matches = true;
        }
      }

      if (matches) {
        await completeMissionUseCase.execute(userId, m.id);
        totalMissionPoints += m.points;
        break; 
      }
    }
    return totalMissionPoints;
  }

  @override
  void dispose() {
    _detector.dispose();
    super.dispose();
  }
}
