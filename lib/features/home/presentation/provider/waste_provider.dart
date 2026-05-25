import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_waste_logs_usecase.dart';
import '../../domain/usecase/log_waste_usecase.dart';

class WasteProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetWasteLogsUseCase getWasteLogsUseCase;
  final LogWasteUseCase logWasteUseCase;

  List<LoggedWaste> _history = [];
  List<LoggedWaste> get history => List.unmodifiable(_history);

  List<WasteItem> _categories = [];
  List<WasteItem> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  bool _shouldOpenGallery = false;
  bool get shouldOpenGallery => _shouldOpenGallery;

  bool _shouldOpenCamera = false;
  bool get shouldOpenCamera => _shouldOpenCamera;

  bool _shouldFocusName = false;
  bool get shouldFocusName => _shouldFocusName;

  void setTabIndex(int index, {bool openGallery = false, bool openCamera = false, bool focusName = false}) {
    _selectedTabIndex = index;
    _shouldOpenGallery = openGallery;
    _shouldOpenCamera = openCamera;
    _shouldFocusName = focusName;
    notifyListeners();
  }

  void consumeOpenGallery() {
    _shouldOpenGallery = false;
  }

  void consumeOpenCamera() {
    _shouldOpenCamera = false;
  }

  void consumeFocusName() {
    _shouldFocusName = false;
  }

  StreamSubscription? _authSubscription;
  StreamSubscription? _logsSubscription;
  Timer? _loadingSafetyTimer;

  WasteProvider({
    required this.getCategoriesUseCase,
    required this.getWasteLogsUseCase,
    required this.logWasteUseCase,
  }) {
    _init();
  }

  Future<void> _init() async {
    refreshCategories();
    
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToLogs(user.uid);
      } else {
        _stopListening();
        _clearUserData();
      }
    });
  }

  void refreshLogs() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _startListeningToLogs(user.uid);
    }
  }

  void _startListeningToLogs(String uid) {
    _stopListening();
    
    if (_history.isEmpty) {
      _isHistoryLoading = true;
      notifyListeners();
    }

    _loadingSafetyTimer?.cancel();
    _loadingSafetyTimer = Timer(const Duration(seconds: 8), () {
      if (_isHistoryLoading) {
        _isHistoryLoading = false;
        notifyListeners();
      }
    });

    _logsSubscription = getWasteLogsUseCase.execute(uid).listen((logs) {
      _history = logs.map((log) {
        // Find matching category from the list we already have
        final category = _categories.cast<WasteItem?>().firstWhere(
          (c) => c?.id == log.category.id,
          orElse: () => null,
        ) ?? log.category;

        return LoggedWaste(
          id: log.id,
          category: category,
          quantity: log.quantity,
          location: log.location,
          timestamp: log.timestamp,
          pointsEarned: log.pointsEarned,
          itemName: log.itemName,
          notes: log.notes,
          imageUrl: log.imageUrl,
        );
      }).toList();
      _isHistoryLoading = false;
      _loadingSafetyTimer?.cancel();
      notifyListeners();
    }, onError: (e) {
      _isHistoryLoading = false;
      _loadingSafetyTimer?.cancel();
      _errorMessage = "Failed to load history: $e";
      notifyListeners();
    });
  }

  void _stopListening() {
    _logsSubscription?.cancel();
    _loadingSafetyTimer?.cancel();
  }

  void _clearUserData() {
    _history = [];
    _isHistoryLoading = false;
    _errorMessage = null;
    notifyListeners();
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

  Future<void> logWaste({
    required WasteItem category,
    required double quantity,
    required String location,
    String? itemName,
    String? notes,
    File? imageFile,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? imageUrl;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        imageUrl = base64Encode(bytes);
      }

      final points = (quantity * category.pointsPerKg).round();
      final log = LoggedWaste(
        id: '',
        category: category,
        quantity: quantity,
        location: location,
        timestamp: DateTime.now(),
        pointsEarned: points,
        itemName: itemName,
        notes: notes,
        imageUrl: imageUrl,
      );

      await logWasteUseCase.execute(user.uid, log);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _stopListening();
    super.dispose();
  }
}
